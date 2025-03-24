import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
import pandas as pd

# Define color palette
palette = {"A": "#a02c2c", "B": "#217821", "C": "#2c5aa0"}

# Generate sample data
np.random.seed(42)
data = pd.DataFrame({
    "x": np.random.normal(size=100),  # 100 random points for x
    "y": np.random.normal(size=100),  # 100 random points for y
    "category": np.random.choice(["A", "B", "C"], size=100, replace=True)  # Random category
})

# Axis limits and breaks
x_axis_min, x_axis_max, x_axis_breaks = -3, 3, 1
y_axis_min, y_axis_max, y_axis_breaks = -3, 3, 1

# Create figure and axis
fig, ax = plt.subplots(figsize=(6, 5))

# Scatter plot
sns.scatterplot(data=data, x="x", y="y", hue="category", palette=palette, alpha=0.8, s=40, edgecolor="black", ax=ax)

ax.set_xlim(x_axis_min, x_axis_max)
ax.set_xticks(np.arange(x_axis_min, x_axis_max + 1, x_axis_breaks))
ax.set_ylim(y_axis_min, y_axis_max)
ax.set_yticks(np.arange(y_axis_min, y_axis_max + 1, y_axis_breaks))

ax.set_title("Scatter Plot Example", fontsize=14)
ax.set_xlabel("X Axis", fontsize=14)
ax.set_ylabel("Y Axis", fontsize=14)

ax.axvline(x=0, linestyle="dashed", color="black", linewidth=1)
ax.axhline(y=0, linestyle="solid", color="black", linewidth=1)

ax.set_facecolor("#f2f2f2")
ax.grid(which="major", linestyle="-", linewidth=0.5, color="#dbe3db")
ax.grid(which="minor", linestyle="-", linewidth=0.25, color="#dbe3db")
ax.spines["top"].set_visible(False)
ax.spines["right"].set_visible(False)
ax.spines["bottom"].set_linewidth(0.5)
ax.spines["left"].set_linewidth(0.5)

ax.tick_params(axis="x", labelsize=12)
ax.tick_params(axis="y", labelsize=12)

plt.show()
