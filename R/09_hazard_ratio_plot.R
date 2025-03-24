# Hazard Ratio Plot

value1 <- abs(rnorm(10)) * 2  # Hazard ratios
ci_lower <- value1 - abs(rnorm(10)) * 0.5  # Lower bound of confidence interval
ci_upper <- value1 + abs(rnorm(10)) * 0.5  # Upper bound of confidence interval

categories <- c("Group A", "Group B", "Group C", "Group D", "Group E", 
                "Group F", "Group G", "Group H", "Group I", "Group J")

data <- data.frame(
  group = categories, 
  hazard_ratio = value1, 
  ci_lower = ci_lower, 
  ci_upper = ci_upper
)

data <- data[order(data$hazard_ratio), ]
data$group <- factor(data$group, levels = data$group)

p1 <- ggplot(data) +
  geom_segment(aes(x = group, xend = group, y = ci_lower, yend = ci_upper), color = "grey", size = 2) +  # CI bars
  geom_point(aes(x = group, y = hazard_ratio), color = rgb(0.2, 0.7, 0.1, 0.5), size = 3) +  # Hazard ratios
  coord_flip() +  # Flip the coordinates for horizontal bars
  theme(
    legend.position = "none",
    panel.background = element_rect(fill = "#f9f9f9", colour = "#f2f2f2", size = 0.5, linetype = "solid"),
    panel.grid.major = element_line(size = 0.5, linetype = 'solid', colour = "#dbe3db"), 
    panel.grid.minor = element_line(size = 0.25, linetype = 'solid', colour = "#dbe3db"),
    panel.border = element_rect(colour = "black", fill = NA, size = 0.2),
    axis.line = element_line(color = "#2d3f44"),
    axis.title.x = element_text(size = 14),
    axis.title.y = element_text(size = 14),
    axis.text.y = element_text(size = 12),
    plot.margin = margin(1, 2, 0, 1)
  ) +
  xlab("") +
  ylab("Hazard Ratio")

p1
