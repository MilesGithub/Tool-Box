# Load necessary libraries
# install.packages(c("limma", "edgeR"))
library(limma)
library(edgeR)

# --- Simulate RNA-Seq Count Data ---
# Let's simulate a simple experiment: 3 control samples, 3 treatment samples
set.seed(1)
ngenes <- 10000
nsamples <- 30
group <- factor(rep(c("Control", "Treatment"), each = 15))

# Simulate baseline means (on log2 scale)
base_means <- rnorm(ngenes, mean = 7, sd = 2.5)

# Create an empty count matrix
counts <- matrix(0, nrow = ngenes, ncol = nsamples)
rownames(counts) <- paste0("Gene", 1:ngenes)
colnames(counts) <- paste0("Sample", 1:nsamples)

# Simulate counts using a negative binomial distribution
# Introduce differential expression for the first 500 genes
dispersion <- 0.1
for (i in 1:ngenes) {
  mean_expr <- 2^base_means[i]
  if (i <= 500) {
    fold_change <- sample(c(0.5, 2), 1)
    mean_treatment <- mean_expr * fold_change
    counts[i, group == "Control"] <- rnbinom(3, mu = mean_expr, size = 1/dispersion)
    counts[i, group == "Treatment"] <- rnbinom(3, mu = mean_treatment, size = 1/dispersion)
  } else {
    counts[i, ] <- rnbinom(nsamples, mu = mean_expr, size = 1/dispersion)
  }
}
counts[counts < 0] <- 0
counts <- round(counts)

cat("Simulated Count Matrix Dimensions:", dim(counts), "\n")

# --- Create DGEList Object ---
dge <- DGEList(counts = counts, group = group)
print(dge$samples)

# --- Filter Low-Expressed Genes ---
design_filter <- model.matrix(~group)
keep <- filterByExpr(dge, design = design_filter)
dge <- dge[keep, , keep.lib.sizes = FALSE] # Subset the DGEList
cat("\nNumber of genes after filtering:", nrow(dge), "\n")

# --- Calculate Normalization Factors ---
dge <- calcNormFactors(dge)
print(dge$samples$norm.factors)

# --- Define the Experimental Design Matrix ---
# ~0 + group removes the intercept and fits group means directly
design <- model.matrix(~0 + group)
colnames(design) <- levels(group) # Make column names more intuitive
print(design)

# --- Run voom ---
# Transforms count data to log2-CPM, estimates the mean-variance relationship
v <- voom(dge, design, plot = TRUE)

# Explore the voom output (EList object)
# head(v$E) # log2-CPM values
# head(v$weights) # Weights associated with each observation

# --- Fit Linear Model ---
# Fit a linear model for each gene using the voom output (logCPM and weights)
fit <- lmFit(v, design)

# --- Define Contrasts ---
# Specify the comparisons you want to make between groups
contrast.matrix <- makeContrasts(TreatmentVsControl = Treatment - Control,
                                 levels = design)
print(contrast.matrix)

# Apply the contrasts to the linear model fit
fit2 <- contrasts.fit(fit, contrast.matrix)

# --- Apply Empirical Bayes Moderation ---
# Borrows information across genes to stabilize variance estimates,
# improving power, especially with small sample sizes.
fit2 <- eBayes(fit2)
summary(decideTests(fit2))

plotSA(fit2, main="Final model: Mean-variance trend")

# --- Extract Top Differentially Expressed Genes ---
# Get a table of the top DE genes, ranked by p-value or adjusted p-value
# coef="TreatmentVsControl" specifies which comparison we want results for
top_results <- topTable(fit2, coef = "TreatmentVsControl", number = 10, sort.by = "P")
print(top_results)

all_results <- topTable(fit2, coef = "TreatmentVsControl", number = Inf, sort.by="none")
head(all_results)

significant_genes <- subset(all_results, adj.P.Val < 0.05)

