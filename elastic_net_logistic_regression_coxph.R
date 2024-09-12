
library(glmnet)
library(survival)

# Simulate data (100 samples, 1000 genes)
n_samples <- 100
n_genes <- 1000

X <- matrix(rnorm(n_samples * n_genes), n_samples, n_genes)
colnames(X) <- paste0("Gene", 1:n_genes)  # Label the columns as genes

true_genes <- c("Gene1", "Gene2", "Gene3")
beta_true <- c(1.5, -1.0, 0.8)

linear_predictor <- X[, 1:3] %*% beta_true
baseline_hazard <- 0.1

surv_time <- rexp(n_samples, rate = baseline_hazard * exp(linear_predictor))
event_status <- rbinom(n_samples, 1, 0.5)

y <- Surv(surv_time, event_status)

# elastic net parameter alpha 0.5
alpha_value <- 0.5

# Perform cross-validation for elastic net model
cv_fit <- cv.glmnet(X, y, family = "cox", alpha = alpha_value)

plot(cv_fit)

best_lambda <- cv_fit$lambda.min
fit <- glmnet(X, y, family = "cox", alpha = alpha_value, lambda = best_lambda)


#Extract selected genes
coef(fit)
coef_df<-data.frame(gene_name=colnames(X), coef=matrix(coef(fit)))

selected_genes <- coef_df[coef_df$coef != 0,]

cat("Selected genes:", selected_genes$gene_name, "\n")

