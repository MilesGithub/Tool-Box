# Load the library
library(gprofiler2)

# --- Example Input ---
my_genes <- c("EGFR", "MYC", "VEGFA", "CDKN2A", "CCND1", "MET", "HIF1A", "AKT1", "PIK3CA", "ERBB2", "TP53", "BRCA1") # Added a couple more

# --- Perform Enrichment Analysis ---
# Use the gost() function
# - query: Vector of gene IDs
# - organism: The organism code (e.g., "hsapiens" for human, "mmusculus" for mouse)
#            Find codes using `gprofiler2::get_organism_data()`.
# - significant: TRUE (default) returns only significant results based on the threshold.
# - correction_method: Method for multiple testing correction (e.g., "g_SCS" (default), "fdr", "bonferroni").
# - user_threshold: The significance threshold (default 0.05).
# - sources: Specify which data sources to query (e.g., "GO:BP", "KEGG", "REAC").

gostres <- gost(query = my_genes,
                organism = "hsapiens",
                significant = TRUE,
                correction_method = "g_SCS")

# --- View Results ---
results_df <- gostres$result

print(head(results_df[, c("query", "source", "term_id", "term_name", "p_value", "intersection_size")]))

# Create a Manhattan plot of the results (plots -log10 p-values)
if (!is.null(gostres)) {
  p <- gostplot(gostres, capped = TRUE, interactive = TRUE)
  print(p)
} else {
  print("No significant results found to plot.")
}
