# Parameters
n_genes <- 1000
n_samples <- 100
genes <- paste0("Gene", 1:n_genes)
samples <- paste0("Sample", 1:n_samples)
group <- factor(rep(c("Control", "Treatment"), each = 50))

# Simulate expression:
# Control: baseline expression
control_expr <- matrix(rnorm(n_genes * 50, mean = 10, sd = 1), nrow = n_genes)

# Treatment: upregulate first 200 genes by 0.3
treatment_expr <- matrix(rnorm(n_genes * 50, mean = 10, sd = 1), nrow = n_genes)
treatment_expr[1:200, ] <- treatment_expr[1:200, ] + 0.3

expr_matrix <- cbind(control_expr, treatment_expr)
rownames(expr_matrix) <- genes
colnames(expr_matrix) <- samples

expr_t <- t(expr_matrix)

# Run PCA
pca <- prcomp(expr_t, center = TRUE, scale. = TRUE)


pca_df <- data.frame(pca$x, Group = group)

# Custom color vector: named by group
custom_colors <- c(Control = "#1f77b4", Treatment = "#ff7f0e")  # blue and orange

# PCA Plot
p1<-ggplot(pca_df, aes(x = PC1, y = PC2, color = Group)) +
  geom_point(size = 2, alpha = 0.85) +
  scale_color_manual(values = custom_colors) +
  theme_minimal() +
  labs(
    title = "PCA of Simulated Gene Expression (100 Samples)",
    x = paste0("PC1 (", round(summary(pca)$importance[2,1] * 100, 1), "%)"),
    y = paste0("PC2 (", round(summary(pca)$importance[2,2] * 100, 1), "%)")
  ) +
  theme(
    legend.position = "none",
    panel.background = element_rect(fill = "#f2f2f2", colour = "#f2f2f2", size = 0.5, linetype = "solid"),
    panel.grid.major = element_line(size = 0.5, linetype = 'solid', colour = "#dbe3db"), 
    panel.grid.minor = element_line(size = 0.25, linetype = 'solid', colour = "#dbe3db"),
    axis.title.x = element_text(size = 14),
    axis.text.x = element_text(size = 12),
    axis.title.y = element_text(size = 14),
    axis.text.y = element_text(size = 12),
    panel.border = element_rect(colour = "black", fill = NA, size = 0.5)
  )

p1


