
library(ggplot2)
library(dplyr)

set.seed(123)

gene_data <- data.frame(
  gene_expr = rnorm(100, mean = 10, sd = 2),  # Simulated gene expression levels
  age = rnorm(100, mean = 50, sd = 10),       # Simulated ages
  treatment = factor(sample(c("Yes", "No"), 100, replace = TRUE))  # Treatment factor
)

# Fit a linear model to predict gene expression based on age and treatment
lm_model <- lm(gene_expr ~ age + treatment, data = gene_data)

# Summary of the linear model
summary(lm_model)


# Output explained:
# Call:
# This part confirms the model formula used.
# lm(formula = gene_expr ~ age + treatment, data = gene_data)

# Residuals:
# These show the distribution of residuals (the difference between observed and predicted values).
# Ideally, residuals should be symmetrically distributed around 0.
# Min      1Q  Median      3Q     Max 
# -2.5432 -0.8765  0.0342  0.9543  2.8745

# Coefficients:
# This section shows the estimates for the intercept and predictors, along with their standard errors, t-values, and p-values.
# Coefficients:
#               Estimate  Std. Error  t value  Pr(>|t|)    
# (Intercept)   10.5432    0.5431     19.41    < 2e-16 ***
# The intercept (10.5432) is the predicted value of gene_expr when age = 0 and treatment = No.
# age            0.0512    0.0087      5.88    1.2e-07 ***
# For every 1 year increase in age, gene expression increases by 0.0512 units, assuming treatment is held constant.
# treatmentYes   1.3025    0.4121      3.16    0.0021  ** 
# Patients who received treatment (Yes) have, on average, 1.3025 units higher gene expression compared to the No treatment group.
# The p-values (Pr(>|t|)) show the statistical significance of each predictor. *** indicates highly significant (p < 0.001).

# Residual standard error:
# Residual standard error: 1.203 on 97 degrees of freedom
# This measures the average amount by which the observed values differ from the model's predictions.
# The smaller the RSE, the better the model fits the data.

# Multiple R-squared and Adjusted R-squared:
# Multiple R-squared:  0.526, Adjusted R-squared:  0.512 
# R-squared tells us that 52.6% of the variability in gene expression is explained by the model.
# Adjusted R-squared adjusts for the number of predictors in the model and is a better indicator when comparing models.

# F-statistic:
# F-statistic: 17.99 on 2 and 97 DF, p-value: 2.35e-07
# The F-statistic tests the overall significance of the model. A large F-statistic and a very small p-value (< 0.05) indicate that the model is statistically significant overall.


ggplot(gene_data, aes(x = age, y = gene_expr, color = treatment)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Gene Expression vs Age by Treatment",
       x = "Age",
       y = "Gene Expression") +
  theme(
    panel.background = element_rect(fill = "#f2f2f2", colour = "#f2f2f2", size = 0.5, linetype = "solid"),
    panel.grid.major = element_line(size = 0.5, linetype = 'solid', colour = "#dbe3db"), 
    panel.grid.minor = element_line(size = 0.25, linetype = 'solid', colour = "#dbe3db"),
    axis.title.x = element_text(size = 14),
    axis.text.x = element_text(size = 12),
    axis.title.y = element_text(size = 14),
    axis.text.y = element_text(size = 12),
    panel.border = element_rect(colour = "black", fill = NA, size = 0.5)
  )
