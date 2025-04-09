# List of packages to check and install
packages <- c("pheatmap", "gplots", "ComplexHeatmap", "ggplot2", "RColorBrewer", "circlize")

# Function to check if a package is installed
load_packages <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    if (pkg %in% rownames(installed.packages())) {
      print(paste0("Package already installed: ", pkg))
    } else if (pkg %in% BiocManager::available()) {
      BiocManager::install(pkg)
      print(paste0("Installed from Bioconductor: ", pkg))
    } else {
      install.packages(pkg)
      print(paste0("Installed from CRAN: ", pkg))
    }
  }
  library(pkg, character.only = TRUE)
  print(paste0("Loaded: ", pkg))
}

# Apply function to each package
lapply(packages, load_packages)


set.seed(1)

# Create a matrix with 30 genes and 12 samples
num_genes <- 30
num_samples <- 12
expression_data <- matrix(rnorm(num_genes * num_samples, mean = 8, sd = 2.5),
                          nrow = num_genes,
                          ncol = num_samples)

rownames(expression_data) <- paste0("Gene", 1:num_genes)
colnames(expression_data) <- paste0("Sample", 1:num_samples)

# Introduce some simulated differential expression for visual patterns
expression_data[1:10, 7:12] <- expression_data[1:10, 7:12] + 5
expression_data[11:20, 7:12] <- expression_data[11:20, 7:12] - 5

# --- Create Sample Annotation Data ---
sample_info <- data.frame(
  Condition = factor(rep(c("Control", "Treatment"), each = 6)),
  Batch = factor(rep(c("B1", "B2", "B3"), times = 4)),
  QualityScore = round(runif(num_samples, min=70, max=100))
)

rownames(sample_info) <- colnames(expression_data)

heatmap_colors <- colorRampPalette(rev(brewer.pal(n = 7, name = "RdYlBu")))(100)

print("Sample Annotation Data:")
print(sample_info)

print("Expression Data (Head):")
print(head(expression_data[, 1:6]))


# --- Define custom colors for annotation tracks ---
condition_colors <- c("Control" = "skyblue", "Treatment" = "tomato")
batch_colors <- c("B1" = "grey50", "B2" = "khaki", "B3" = "darkseagreen")

annotation_color_list <- list(
  Condition = condition_colors,
  Batch = batch_colors,
  QualityScore = c("white", "orange")
)

# -----------------------------
# -------- pheatmap -----------
# -----------------------------

pheatmap(
  expression_data,
  main = "pheatmap Example",
  
  # --- Data Scaling and Clustering ---
  scale = "row",
  clustering_distance_rows = "correlation",
  clustering_distance_cols = "euclidean",
  cluster_rows = TRUE,
  cluster_cols = TRUE,
  
  # --- Annotations ---
  annotation_col = sample_info,
  annotation_colors = annotation_color_list,
  
  # --- Appearance ---
  color = heatmap_colors
  border_color = "grey60",
  fontsize = 8,
  fontsize_row = 6,
  fontsize_col = 8,
  show_rownames = TRUE,
  show_colnames = TRUE
)



# -----------------------------
# -------- heatmap.2 -----------
# -----------------------------


cond_col_map <- condition_colors[sample_info$Condition]
batch_col_map <- batch_colors[sample_info$Batch]

col_annotation_colors <- cbind(Condition = cond_col_map, Batch = batch_col_map)

col_annotation_colors <- cond_col_map 

heatmap.2(
  expression_data,
  main = "heatmap.2 Example",
  
  # --- Data Scaling and Clustering ---
  scale = "row",
  Rowv = TRUE,
  Colv = TRUE,
  distfun = function(x) dist(x, method="euclidean"),
  hclustfun = function(x) hclust(x, method="ward.D2"),

  # --- Annotations ---
  ColSideColors = col_annotation_colors,
  
  # --- Appearance ---
  col = heatmap_colors,
  trace = "none",         # Turn off trace lines inside heatmap
  density.info = "none",  # Turn off density plot in key
  key = TRUE,
  keysize = 1.0,
  margins = c(8, 8),
  cexRow = 0.6,
  cexCol = 0.8
)


# --- Scaling Data BEFORE plotting ---

scaled_expression_data <- t(scale(t(expression_data)))

# --- Create a HeatmapAnnotation object ---
ha_column_annotation <- HeatmapAnnotation(
  df = sample_info,
  col = list(Condition = condition_colors,
             Batch = batch_colors),
  annotation_name_side = "left",
  simple_anno_size = unit(0.3, "cm")
)

# --- Generate the ComplexHeatmap ---
ht <- Heatmap(
  scaled_expression_data,
  name = "Z-Score",
  
  # --- Annotations ---
  top_annotation = ha_column_annotation,
  
  # --- Clustering ---
  cluster_rows = TRUE,
  cluster_columns = TRUE,
  clustering_distance_rows = "correlation",
  clustering_distance_columns = "euclidean",
  clustering_method_rows = "ward.D2",
  clustering_method_columns = "ward.D2",
  
  # --- Appearance ---
  column_title = "ComplexHeatmap Example", 
  col = heatmap_colors,
  
  # Control row/column label appearance
  show_row_names = TRUE,
  row_names_gp = gpar(fontsize = 6),
  show_column_names = TRUE,
  column_names_gp = gpar(fontsize = 8),
  
  # Control dendrogram appearance
  show_row_dend = TRUE,
  row_dend_width = unit(15, "mm"),
  show_column_dend = TRUE,
  column_dend_height = unit(15, "mm"),
  
  # Heatmap legend parameters
  heatmap_legend_param = list(
    title = "Z-Score",
    at = c(-2, 0, 2),
    labels = c("Low", "Medium", "High")
  )
)

# --- Draw the Heatmap ---
# ComplexHeatmap objects are created first, then drawn
draw(ht, heatmap_legend_side = "right", annotation_legend_side = "bottom")




# --- ** NEW STEP: Filter out rows with zero variance ** ---
# Calculate row variances
row_variances <- apply(expression_data, 1, var)

# Check which rows have variance > 0 (add a small epsilon for numerical stability if needed)
non_zero_variance_rows <- row_variances > 1e-8 # Or simply > 0

# Subset the expression data to keep only rows with variance
filtered_expression_data <- expression_data[non_zero_variance_rows, ]

# Check dimensions (optional)
print(paste("Original dimensions:", paste(dim(expression_data), collapse="x")))
print(paste("Filtered dimensions:", paste(dim(filtered_expression_data), collapse="x")))


# --- Scaling Data BEFORE plotting ---
# Now scale the *filtered* data
scaled_expression_data <- t(scale(t(filtered_expression_data)))

# --- Optional: Check for NaNs after scaling (should be none if filtering worked) ---
# print(paste("Any NaNs after scaling:", any(is.na(scaled_expression_data))))

correlation_distance <- function(x) {
  as.dist(1 - cor(t(x)))
}


# --- Create a HeatmapAnnotation object (using previously defined colors/info) ---
condition_colors <- c("Control" = "skyblue", "Treatment" = "tomato")
batch_colors <- c("B1" = "grey50", "B2" = "khaki", "B3" = "darkseagreen")

ha_column_annotation <- HeatmapAnnotation(
  df = sample_info,
  col = list(Condition = condition_colors,
             Batch = batch_colors)
)

# --- Define heatmap colors ---
heatmap_colors <- colorRampPalette(rev(brewer.pal(n = 7, name = "RdYlBu")))(100)


# --- Generate the ComplexHeatmap (using filtered and scaled data) ---
ht <- Heatmap(
  scaled_expression_data,
  name = "Z-Score",
  
  top_annotation = ha_column_annotation,
  
  # Clustering options with custom correlation distance
  cluster_rows = TRUE,
  cluster_columns = TRUE,
  clustering_distance_rows = correlation_distance
  clustering_distance_columns = "euclidean",
  clustering_method_rows = "ward.D2",
  clustering_method_columns = "ward.D2",
  
  # Appearance adjustments
  column_title = "ComplexHeatmap Example (Filtered)",
  col = heatmap_colors,
  show_row_names = TRUE,
  row_names_gp = gpar(fontsize = 6),
  show_column_names = TRUE,
  column_names_gp = gpar(fontsize = 8),
  show_row_dend = TRUE,
  row_dend_width = unit(15, "mm"),
  show_column_dend = TRUE,
  column_dend_height = unit(15, "mm"),
  heatmap_legend_param = list(
    title = "Z-Score",
    at = c(-2, 0, 2),
    labels = c("Low", "Medium", "High")
  )
)

draw(ht, heatmap_legend_side = "right", annotation_legend_side = "right")


