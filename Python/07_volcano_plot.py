import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Generate data
np.random.seed(42)
data = pd.DataFrame({
    "gene": ["Gene" + str(i) for i in range(1, 1001)],
    "logFC": np.random.normal(0, 2, 1000),
    "pvalue": np.random.uniform(0, 1, 1000)
})

# Compute -log10(p-value)
data["neg_log"] = -np.log10(data["pvalue"])

# Thresholds
fold_change_threshold = 1
pvalue_threshold = 0.05

# Axis limits
x_axis_min, x_axis_max, x_axis_breaks = -10, 10, 1
y_axis_min, y_axis_max, y_axis_breaks = 0, 10, 1

# Define colors
data["significant"] = (abs(data["logFC"]) > fold_change_threshold) & (data["pvalue"] < pvalue_threshold)
colors = {True: "#1a1a1a", False: "grey"}

# Create figure
fig, ax = plt.subplots(figsize=(7, 6))

# Scatter plot
sns.scatterplot(data=data, x="logFC", y="neg_log", hue="significant", palette=colors, edgecolor="black", s=30, alpha=0.8, ax=ax)

ax.set_xlim(x_axis_min, x_axis_max)
ax.set_xticks(np.arange(x_axis_min, x_axis_max + 1, x_axis_breaks))
ax.set_ylim(y_axis_min, y_axis_max)
ax.set_yticks(np.arange(y_axis_min, y_axis_max + 1, y_axis_breaks))

ax.set_title("Volcano Plot", fontsize=14)
ax.set_xlabel("Log2 Fold Change", fontsize=14)
ax.set_ylabel("-Log10 P-value", fontsize=14)

ax.axvline(x=0, linestyle="dashed", color="black", linewidth=1)
ax.axvline(x=fold_change_threshold, linestyle="dashed", color="black", linewidth=1)
ax.axvline(x=-fold_change_threshold, linestyle="dashed", color="black", linewidth=1)
ax.axhline(y=-np.log10(pvalue_threshold), linestyle="dashed", color="black", linewidth=1)

ax.set_facecolor("#f2f2f2")
ax.grid(which="major", linestyle="-", linewidth=0.5, color="#dbe3db")
ax.grid(which="minor", linestyle="-", linewidth=0.25, color="#dbe3db")
ax.spines["top"].set_visible(False)
ax.spines["right"].set_visible(False)
ax.spines["bottom"].set_linewidth(0.5)
ax.spines["left"].set_linewidth(0.5)

ax.get_legend().remove()

plt.show()
