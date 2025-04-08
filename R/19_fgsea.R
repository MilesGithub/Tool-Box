# Load necessary libraries
library(fgsea)
library(data.table)
library(ggplot2)

# Prepare a ranked list of genes
# Genes are ranked by a statistic like log2FoldChange, t-statistic, or sign(logFC) * -log10(pvalue).

set.seed(1)
num_genes <- 1000
gene_names <- paste0("Gene", 1:num_genes)

# Simulate a statistic (e.g., log2 fold change or t-statistic)
gene_stats <- rnorm(num_genes, mean = 0, sd = 1.5)
names(gene_stats) <- gene_names

up_genes <- paste0("Gene", 1:50)
gene_stats[up_genes] <- gene_stats[up_genes] + rnorm(length(up_genes), mean = 2.5, sd = 0.5)

down_genes <- paste0("Gene", (num_genes - 49):num_genes)
gene_stats[down_genes] <- gene_stats[down_genes] - rnorm(length(down_genes), mean = 2.5, sd = 0.5)

# Sort the genes by the statistic in descending order
ranked_genes <- sort(gene_stats, decreasing = TRUE)

# Check the structure: named numeric vector
print("Top ranked genes:")
head(ranked_genes)
print("Bottom ranked genes:")
tail(ranked_genes)

# Prepare gene sets (pathways)
# Load from GMT files (e.g., from MSigDB) using `gmtPathways()` function in fgsea.

example_pathways <- list(
  Pathway_Up = up_genes,
  Pathway_Middle = paste0("Gene", sample(101:900, 70)), # A pathway with no strong bias
  Pathway_Down = down_genes,
  Pathway_Mixed = c(paste0("Gene", 201:225), paste0("Gene", 801:825)) # Some up, some down
)

print("Structure of example pathways:")
str(example_pathways, list.len=3)

# --- Run fGSEA ---

fgsea_results <- fgsea(
  pathways = example_pathways,
  stats = ranked_genes,
  minSize = 15,      # Minimum size of a gene set considered
  maxSize = 500,     # Maximum size of a gene set considered
  nPermSimple = 1000 # Number of permutations (use more like 10000+ for real data)
)

# --- Explore and Visualize Results ---

# Examine the results table

print("fGSEA Results Table:")
print(fgsea_results)

# Order results by significance (adjusted p-value)
fgsea_results_ordered <- fgsea_results[order(padj)]
print("fGSEA Results Ordered by Adjusted P-value:")
print(fgsea_results_ordered)

# Key columns:
# - pathway: Name of the gene set.
# - pval: Nominal p-value from permutation test.
# - padj: Benjamini-Hochberg adjusted p-value.
# - ES: Enrichment Score. Measures the degree to which a gene set is overrepresented at the top or bottom of the ranked list.
# - NES: Normalized Enrichment Score. ES normalized for gene set size and correlations. Allows comparison across different gene sets.
# - size: Number of genes in the pathway after filtering by genes present in the `stats` vector.
# - leadingEdge: List column containing genes that contribute most to the ES (the core enrichment genes).

# Visualize results

# Plot enrichment score plot for a specific pathway
if ("Pathway_Up" %in% fgsea_results$pathway) {
  print(plotEnrichment(example_pathways[["Pathway_Up"]], ranked_genes) +
          ggtitle("Enrichment Plot for Pathway_Up"))
}

if ("Pathway_Down" %in% fgsea_results$pathway) {
  print(plotEnrichment(example_pathways[["Pathway_Down"]], ranked_genes) +
          ggtitle("Enrichment Plot for Pathway_Down"))
}

top_pathways_positive <- fgsea_results[ES > 0][head(order(padj), n = 10), pathway]
top_pathways_negative <- fgsea_results[ES < 0][head(order(padj), n = 10), pathway]
top_pathways <- c(top_pathways_positive, rev(top_pathways_negative)) # Combine

if (length(top_pathways) > 0) {
  print("Plotting GSEA Table for top pathways:")
  plotGseaTable(example_pathways[top_pathways],
                ranked_genes,
                fgsea_results,
                gseaParam = 0.5)
} else {
  print("No significant pathways found to plot in table format.")
}

fgsea_results_ordered[, leadingEdge := vapply(leadingEdge, paste, character(1), collapse = ", ")]
print("fGSEA Results with collapsed leadingEdge:")
print(fgsea_results_ordered[, .(pathway, padj, NES, size, leadingEdge)])