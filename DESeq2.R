# Load necessary libraries
library(DESeq2)
library(org.Hs.eg.db)  # Replace with appropriate annotation package if working with a different organism (e.g., org.Mm.eg.db for mouse)

countData <- countData[, colnames(countData) %in% rownames(colData)]
countData <- countData[, rownames(colData)]
all(rownames(colData) %in% colnames(countData))


# Example DESeq2 dataset (replace with your dataset)
dds <- DESeqDataSetFromMatrix(countData = countData, colData = colData, design = ~ condition)
dds <- estimateSizeFactors(dds)
idx <- rowSums(counts(dds, normalized = TRUE) >= 5) >= 3
dds <- dds[idx,]

# Run DESeq2 analysis
dds <- DESeq(dds)
res <- results(dds)

# Add gene symbols to DESeq2 results using annotation package (replace 'ENSEMBL' with appropriate keytype if needed)
# rownames(res) should contain gene IDs (e.g., ENSEMBL IDs)
res$gene_symbol <- mapIds(org.Hs.eg.db, keys = rownames(res), column = "SYMBOL", keytype = "ENSEMBL", multiVals = "first")

# View the DESeq2 results with gene names
head(res)

# Optionally, you can remove rows with NA symbols if needed
res <- na.omit(res)

# Save the results to a CSV file
write.csv(as.data.frame(res), file = "DESeq2_results_with_gene_names.csv")

