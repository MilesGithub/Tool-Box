# --- Load Required Library ---
library(xCell)

# --- Prepare Input Data ---
# Create a example expression matrix
# (Rows = Genes, Columns = Samples)
gene_names <- c("CD8A", "CD4", "FOXP3", "CD19", "CD68", "ACTB", "GAPDH", "EPCAM", "KRT19", "PTPRC")
sample_names <- c("Sample1", "Sample2", "Sample3", "Sample4")

# Generate some random-like expression data
set.seed(1)
expression_matrix <- matrix(abs(rnorm(length(gene_names) * length(sample_names), mean = 8, sd = 2)),
                          nrow = length(gene_names),
                          ncol = length(sample_names))

rownames(expression_matrix) <- gene_names
colnames(expression_matrix) <- sample_names

print(head(expression_matrix[,1:min(ncol(expression_matrix), 4)]))

# --- Run xCell Analysis ---
xcell_scores <- xCellAnalysis(expression_matrix)
print("xCell analysis complete.")

print("Dimensions of the xCell scores matrix (Cell Types x Samples):")
print(dim(xcell_scores))

print("First few rows (cell types) and columns (samples) of the xCell scores:")
print(head(xcell_scores[,1:min(ncol(xcell_scores), 4)])) # Show first few cell types and up to 4 samples
