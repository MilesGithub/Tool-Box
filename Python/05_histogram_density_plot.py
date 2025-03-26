import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

# Generate sample data
np.random.seed(42)
data = np.random.normal(size=1000)  # 1000 random normal values

# Axis limits and breaks
x_axis_min, x_axis_max, x_axis_breaks = -5, 5, 1
y_axis_min, y_axis_max, y_axis_breaks = 0, 0.5, 0.1

# Create figure and axis
fig, ax = plt.subplots(figsize=(6, 5))

# Histogram
sns.histplot(data, bins=np.arange(x_axis_min, x_axis_max + 0.2, 0.2), 
             stat="density", color="#2c5aa0", edgecolor="black", alpha=0.2, ax=ax)

# Density plot
sns.kdeplot(data, fill=True, color="#a02c2c", alpha=0.1, ax=ax)

ax.set_xlim(x_axis_min, x_axis_max)
ax.set_xticks(np.arange(x_axis_min, x_axis_max + 1, x_axis_breaks))
ax.set_ylim(y_axis_min, y_axis_max)
ax.set_yticks(np.arange(y_axis_min, y_axis_max + 0.1, y_axis_breaks))

ax.set_title("Histogram with Density Overlay", fontsize=14)
ax.set_xlabel("Values", fontsize=14)
ax.set_ylabel("Density", fontsize=14)

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
