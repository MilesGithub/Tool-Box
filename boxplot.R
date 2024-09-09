# Boxplot

df <- data.frame(
  group = rep(c("A", "B", "C"), each = 100),  # Three groups
  value = c(rnorm(100, mean = 5), rnorm(100, mean = 7), rnorm(100, mean = 6))  # Random values
)

p1<-ggplot(df, aes(x = group, y = value)) +
  geom_boxplot(fill = "#2c5aa0", color = "#1a1a1a", alpha = 0.1, outlier.shape = NA) +  # Boxplot
  geom_jitter(width = 0.2, size = 1.5, color = "#a02c2c", alpha = 0.6) +  # Add jittered points
  labs(title = "Boxplot with Jittered Points", x = "Group", y = "Value") +
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
