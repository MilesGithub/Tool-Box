import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
import numpy as np

# Generate sample data
np.random.seed(42)
df = pd.DataFrame({
    "group": np.repeat(["A", "B", "C"], 100),  # Three groups
    "value": np.concatenate([
        np.random.normal(loc=5, size=100),
        np.random.normal(loc=7, size=100),
        np.random.normal(loc=6, size=100)
    ])  # Random values
})

# Y-axis limits and breaks
y_axis_min = 0
y_axis_max = 10
y_axis_breaks = 1

# Create figure and axis
fig, ax = plt.subplots(figsize=(6, 5))

# Boxplot
sns.boxplot(data=df, x="group", y="value", ax=ax, 
            color="#2c5aa0", linewidth=1.2, fliersize=0,  # Hide outliers
            boxprops=dict(alpha=0.1), whiskerprops=dict(color="#1a1a1a"),
            medianprops=dict(color="#1a1a1a"), capprops=dict(color="#1a1a1a"))

# Jittered points
sns.stripplot(data=df, x="group", y="value", ax=ax, 
              color="#a02c2c", alpha=0.6, jitter=0.2, size=3)

ax.set_ylim(y_axis_min, y_axis_max)
ax.set_yticks(np.arange(y_axis_min, y_axis_max + 1, y_axis_breaks))

ax.set_title("Boxplot with Jittered Points", fontsize=14)
ax.set_xlabel("Group", fontsize=14)
ax.set_ylabel("Value", fontsize=14)

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
