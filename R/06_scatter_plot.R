# Scatter Plot

palette <- c("#a02c2c", "#217821", "#2c5aa0")

data <- data.frame(
  x = rnorm(100),  # 100 random points for x
  y = rnorm(100),  # 100 random points for y
  category = sample(c("A", "B", "C"), 100, replace = TRUE)  # Random category A or B
)

x_axis_min<- -3
x_axis_max<- 3
x_axis_breaks<-1

y_axis_min<- -3
y_axis_max<- 3
y_axis_breaks<-1

p1<-ggplot(data, aes(x=x, y=y, color = category)) +
  geom_point(alpha = 1.2, size=2) +
  scale_y_continuous(limits = c(y_axis_min, y_axis_max), breaks = seq(y_axis_min, y_axis_max, by = y_axis_breaks)) +
  scale_x_continuous(limits = c(x_axis_min, x_axis_max), breaks = seq(x_axis_min, x_axis_max, by = x_axis_breaks)) +
  labs(title = "Scatter Plot Example", x = "X Axis", y = "Y Axis") +
  geom_vline(xintercept=0, linetype="dashed", color = "black") +
  geom_hline(yintercept=0, linetype="solid", color = "black") +
  scale_color_manual(values = palette) +
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
