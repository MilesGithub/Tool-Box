# KM Plot

library(survival)
library(survminer)

df <- data.frame(
  time = c(
    rexp(50, rate = 0.05),  # Longer survival times for Treatment group
    rexp(50, rate = 0.1)    # Shorter survival times for Control group
  ),
  status = c(
    sample(c(0, 1), 50, replace = TRUE),  # Censoring or event for Treatment group
    sample(c(0, 1), 50, replace = TRUE)   # Censoring or event for Control group
  ),
  group = rep(c("Treatment", "Control"), each = 50)  # Group variable
)

km_fit <- survfit(Surv(time, status) ~ group, data = df)

p1 <- ggsurvplot(
  km_fit,                     # survfit object with calculated statistics.
  data = df,                  # Data used to fit survival curves.
  risk.table = TRUE,          # Show risk table.
  pval = TRUE,                # Show p-value of log-rank test.
  conf.int = TRUE,            # Show confidence intervals for survival curves.
  palette = c("#E69F00", "#56B4E9"), # Colors for groups.
  xlim = c(0, 35),           # X axis limits.
  xlab = "Time in days",      # Customize X axis label.
  break.time.by = 5,        # Break X axis in time intervals.
  risk.table.y.text.col = TRUE, # Color risk table text annotations.
  risk.table.height = 0.2,   # Height of the risk table.
  risk.table.y.text = FALSE,  # Show bars instead of names in risk table legend.
  ncensor.plot = TRUE,        # Plot number of censored subjects at time t.
  ncensor.plot.height = 0.2, # Height of the censor plot.
  surv.median.line = "hv",    # Add median survival line.
  legend.labs = c("Treatment", "Control"), # Legend labels.
  ggtheme = theme(
    legend.position = "none", # Hide legend.
    panel.background = element_rect(fill = "#f2f2f2", colour = "#f2f2f2", size = 0.5, linetype = "solid"),
    panel.grid.major = element_line(size = 0.5, linetype = 'solid', colour = "#dbe3db"), 
    panel.grid.minor = element_line(size = 0.25, linetype = 'solid', colour = "#dbe3db"),
    axis.title.x = element_text(size = 14),
    axis.text.x = element_text(size = 12),
    axis.title.y = element_text(size = 14),
    axis.text.y = element_text(size = 12),
    panel.border = element_rect(colour = "black", fill = NA, size = 0.5)
  )
)

# Print the plot
p1
