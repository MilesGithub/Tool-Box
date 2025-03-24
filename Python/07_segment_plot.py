import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Data
df = pd.DataFrame({
    "event": ["Project A", "Task B", "Task B", "Event C", "Activity D", "Activity D", "Process E"],
    "start_day": [10, 20, 80, 30, 40, 100, 50],
    "end_day": [150, 50, 120, 170, 80, 150, 190],
    "outcome": [-10, 5, 10, 15, -5, 5, 0]  # Example outcomes or scores
})

# Sorting events so they appear in order on the y-axis
df["event"] = pd.Categorical(df["event"], categories=df["event"][::-1], ordered=True)

# Create figure
fig, ax = plt.subplots(figsize=(8, 5))

# Color mapping
norm = plt.Normalize(df["outcome"].min(), df["outcome"].max())
cmap = plt.get_cmap("coolwarm")

# Plot segments
for _, row in df.iterrows():
    ax.plot([row["start_day"], row["end_day"]], [row["event"], row["event"]],
            color=cmap(norm(row["outcome"])), linewidth=5)

ax.scatter(df["start_day"], df["event"], color="black", s=40, label="Start")
ax.scatter(df["end_day"], df["event"], color="black", s=40, label="End")

ax.axvline(x=100, linestyle="dashed", color="black", linewidth=1)
ax.axvline(x=0, linestyle="dashed", color="black", linewidth=1)

ax.set_xlabel("Time (days)", fontsize=14)
ax.set_ylabel("Category", fontsize=14)
ax.set_title("Segment Plot", fontsize=14)

ax.set_xticks(range(0, 201, 20))

ax.set_facecolor("#f9f9f9")
ax.grid(which="major", linestyle="-", linewidth=0.5, color="#dbe3db")
ax.spines["top"].set_visible(False)
ax.spines["right"].set_visible(False)
ax.spines["bottom"].set_linewidth(0.5)
ax.spines["left"].set_linewidth(0.5)

plt.show()
