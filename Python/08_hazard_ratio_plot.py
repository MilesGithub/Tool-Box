import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# Generate data
np.random.seed(42)
hazard_ratios = np.abs(np.random.randn(10)) * 2  # Hazard ratios
ci_lower = hazard_ratios - np.abs(np.random.randn(10)) * 0.5  # Lower bound CI
ci_upper = hazard_ratios + np.abs(np.random.randn(10)) * 0.5  # Upper bound CI

categories = ["Group A", "Group B", "Group C", "Group D", "Group E", 
              "Group F", "Group G", "Group H", "Group I", "Group J"]

df = pd.DataFrame({
    "group": categories,
    "hazard_ratio": hazard_ratios,
    "ci_lower": ci_lower,
    "ci_upper": ci_upper
})

# Sort data by hazard ratio
df = df.sort_values(by="hazard_ratio")
df["group"] = pd.Categorical(df["group"], categories=df["group"], ordered=True)

# Plot
fig, ax = plt.subplots(figsize=(8, 5))

# Confidence interval bars
ax.hlines(df["group"], df["ci_lower"], df["ci_upper"], color="grey", linewidth=2)

# Hazard ratio points
ax.scatter(df["hazard_ratio"], df["group"], color=(0.2, 0.7, 0.1, 0.5), s=50)

ax.set_xlabel("Hazard Ratio", fontsize=14)
ax.set_ylabel("")

ax.set_facecolor("#f9f9f9")
ax.grid(which="major", linestyle="-", linewidth=0.5, color="#dbe3db")
ax.spines["top"].set_visible(False)
ax.spines["right"].set_visible(False)
ax.spines["left"].set_visible(False)
ax.spines["bottom"].set_linewidth(0.5)

plt.show()
