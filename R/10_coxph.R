# Load necessary libraries
library(survival)  # For survival analysis
library(ggplot2)   # For data visualization
library(dplyr)     # For data manipulation

# Example data
set.seed(123)
surv_data <- data.frame(
  time = rexp(100, rate = 0.1),                   # Simulated time-to-event data
  status = sample(0:1, 100, replace = TRUE),     # Randomly simulate event occurrence (0 = censored, 1 = event occurred)
  age = rnorm(100, mean = 60, sd = 10),           # Simulated ages
  treatment = factor(sample(c("Yes", "No"), 100, replace = TRUE)), # Randomly assign treatment
  sex = factor(sample(c("Male", "Female"), 100, replace = TRUE)), # Randomly assign sex
  bmi = rnorm(100, mean = 25, sd = 5)             # Simulated BMI values
)

# Fit a Cox proportional hazards model with multiple predictors
cox_model <- coxph(Surv(time, status) ~ age + treatment + sex + bmi, data = surv_data)

# Summary of the Cox model
model_summary <- summary(cox_model)

# Output explained:

# Call:
# This part confirms the model formula used for fitting the Cox model.
# coxph(Surv(time, status) ~ age + treatment + sex + bmi, data = surv_data)

# n= 100
# The number of observations used in the model.

# Likelihood ratio test:
# The likelihood ratio test compares the fit of the Cox model with and without the predictors.
# The test statistic and p-value indicate whether the model with predictors fits significantly better than a model without any predictors.

# Coefficients:
# This section provides the estimated effects of the predictors on the hazard rate.
#              coef exp(coef) se(coef)      z      p
# age         0.015     1.015   0.010   1.50   0.134
# treatmentYes 0.690     1.995   0.412   1.68   0.093
# sexMale      -0.250    0.778   0.400  -0.63   0.527
# bmi          0.020     1.020   0.015   1.33   0.185
# 
# - **coef**: The estimated coefficient for each predictor.
# - **exp(coef)**: The hazard ratio. For `age`, it's 1.015; for `treatmentYes`, it's 1.995; for `sexMale`, it's 0.778; and for `bmi`, it's 1.020.
#   - Hazard ratio interpretation:
#     - **age**: Hazard increases by 1.5% per year.
#     - **treatmentYes**: Treatment group has about twice the hazard compared to control.
#     - **sexMale**: Males have a lower hazard (22% reduction) compared to females.
#     - **bmi**: A 1-unit increase in BMI is associated with a 2% increase in hazard.
# - **se(coef)**: The standard error of the coefficient estimate.
# - **z**: The z-value (coefficient divided by its standard error). It tests the null hypothesis that the coefficient is zero.
# - **p**: The p-value associated with the z-value. It tests the null hypothesis that the coefficient is zero.

# Concordance:
# The concordance index (C-index) measures how well the model discriminates between patients with different outcomes.

# Create a data frame for plotting hazard ratios
hr_df <- data.frame(
  Predictor = rownames(model_summary$coefficients),
  HazardRatio = exp(model_summary$coefficients[, "coef"]),
  LowerCI = exp(model_summary$coefficients[, "coef"] - 1.96 * model_summary$coefficients[, "se(coef)"]),
  UpperCI = exp(model_summary$coefficients[, "coef"] + 1.96 * model_summary$coefficients[, "se(coef)"])
)

# Plot hazard ratios with confidence intervals, with predictors on the y-axis
ggplot(hr_df, aes(x = HazardRatio, y = Predictor, xmin = LowerCI, xmax = UpperCI)) +
  geom_point() +  # Plot points for hazard ratios
  geom_errorbarh(height = 0.2) +  # Add horizontal error bars for confidence intervals
  geom_vline(xintercept = 1, linetype = "dashed", color = "red") +  # Add a reference line at HR = 1
  labs(title = "Hazard Ratios with 95% Confidence Intervals",
       x = "Hazard Ratio",
       y = "Predictor") +
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
