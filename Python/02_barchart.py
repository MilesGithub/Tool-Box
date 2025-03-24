import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
import numpy as np

# Sample data with error bars
df = pd.DataFrame({
    "group": ["A", "B", "C", "D"],
    "value": [10, 15, 7, 20],
    "error": [2, 1.5, 3, 2.5]
})

# Y-axis limits and breaks
y_axis_min = 0
y_axis_max = 30
y_axis_breaks = 5

# Create the bar plot
fig, ax = plt.subplots(figsize=(6, 5))

sns.barplot(data=df, x="group", y="value", color="#2c5aa0", edgecolor="#1a1a1a", width=0.6, ax=ax)

# Add error bars
ax.errorbar(df["group"], df["value"], yerr=df["error"], fmt="none", color="black", capsize=4, linewidth=1)


ax.set_ylim(y_axis_min, y_axis_max)
ax.set_yticks(np.arange(y_axis_min, y_axis_max + 1, y_axis_breaks))

ax.set_title("Bar Plot with Error Bars", fontsize=14)
ax.set_xlabel("Group", fontsize=14)
ax.set_ylabel("Value", fontsize=14)

ax.set_facecolor("#f2f2f2")
ax.grid(which="minor", linestyle="-", linewidth=0.25, color="#dbe3db")
ax.spines["top"].set_visible(False)
ax.spines["right"].set_visible(False)
ax.spines["bottom"].set_linewidth(0.5)
ax.spines["left"].set_linewidth(0.5)

ax.tick_params(axis="x", labelsize=12)
ax.tick_params(axis="y", labelsize=12)

plt.show()
