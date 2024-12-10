# Segment Plot

df <- data.frame(
  event = c("Project A", "Task B", "Task B", "Event C", "Activity D", "Activity D", "Process E"),
  start_day = c(10, 20, 80, 30, 40, 100, 50),
  end_day = c(150, 50, 120, 170, 80, 150, 190),
  outcome = c(-10, 5, 10, 15, -5, 5, 0)  # Example outcomes or scores
)

p1<-ggplot(df, aes(x = start_day, y = event, colour = outcome)) +
  geom_segment(aes(xend = end_day, yend = event), size = 2.5) +  # Add segments from start to end days
  geom_point(size = 2) +  # Points at start days
  geom_point(aes(x = end_day), size = 2) +  # Points at end days
  labs(title = "Segment Plot", x = "Time(days)", y = "Category") +
  geom_vline(xintercept = 100, linetype = "dashed", color = "black", size = 0.7) +  # Midline (e.g., a reference point)
  geom_vline(xintercept = 0, linetype = "dashed", color = "black", size = 0.7) +   # Vertical line at zero
  scale_x_continuous(breaks = seq(0, 200, by = 20)) +  # Set x-axis breaks (adjust as needed)
  scale_colour_gradient2(low = "blue", mid = "#cccccc", high = "red", midpoint = 0) +  # Color gradient for outcome
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
  )

p1