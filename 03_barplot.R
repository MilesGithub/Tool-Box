library(ggplot2)

# Sample data with error bars
df <- data.frame(
  group = c("A", "B", "C", "D"),
  value = c(10, 15, 7, 20),
  error = c(2, 1.5, 3, 2.5)  # Error values
)

y_axis_min <- 0
y_axis_max <- 30
y_axis_breaks <- 5

# Bar plot with error bars
p1 <- ggplot(df, aes(x = group, y = value)) +
  geom_bar(stat = "identity", fill = "#2c5aa0", color = "#1a1a1a", width = 0.6) +  # Bar plot
  geom_errorbar(aes(ymin = value - error, ymax = value + error), 
                width = 0.2, color = "black", size = 0.8) +  # Error bars
  scale_y_continuous(limits = c(y_axis_min, y_axis_max), breaks = seq(y_axis_min, y_axis_max, by = y_axis_breaks)) +
  labs(title = "Bar Plot with Error Bars", x = "Group", y = "Value") +
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
