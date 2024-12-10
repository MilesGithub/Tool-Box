# Histogram Density Plot

data <- data.frame(
  values = rnorm(1000)  # 1000 random normal values
)

x_axis_min <- -5
x_axis_max <- 5
x_axis_breaks <- 1

y_axis_min <- 0
y_axis_max <- 0.5
y_axis_breaks <- 0.1

p1<-ggplot(data, aes(x = values)) +
  geom_histogram(aes(y = ..density..), binwidth = 0.2, fill = "#2c5aa0", color = "black", alpha = 0.2) +
  geom_density(fill = "#a02c2c", alpha = 0.1) +
  scale_y_continuous(limits = c(y_axis_min, y_axis_max), breaks = seq(y_axis_min, y_axis_max, by = y_axis_breaks)) +
  scale_x_continuous(limits = c(x_axis_min, x_axis_max), breaks = seq(x_axis_min, x_axis_max, by = x_axis_breaks)) +
  labs(title = "Histogram with Density Overlay", x = "Values", y = "Density") +
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

