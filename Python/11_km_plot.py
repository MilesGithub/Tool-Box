import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from lifelines import KaplanMeierFitter
from lifelines.statistics import logrank_test

# Simulate data
np.random.seed(123)
df = pd.DataFrame({
    "time": np.concatenate([np.random.exponential(scale=1/0.05, size=50), np.random.exponential(scale=1/0.1, size=50)]),  # Survival times for two groups
    "status": np.concatenate([np.random.choice([0, 1], size=50), np.random.choice([0, 1], size=50)]),  # Censoring or event
    "group": ["Treatment"] * 50 + ["Control"] * 50  # Group variable
})

# Fit Kaplan-Meier estimator
kmf = KaplanMeierFitter()

# Plot Kaplan-Meier curves
plt.figure(figsize=(8, 6))

# Fit and plot for Treatment group
kmf.fit(df[df["group"] == "Treatment"]["time"], event_observed=df[df["group"] == "Treatment"]["status"], label="Treatment")
kmf.plot(ci_show=True, color="#E69F00", linestyle='-', linewidth=2)

# Fit and plot for Control group
kmf.fit(df[df["group"] == "Control"]["time"], event_observed=df[df["group"] == "Control"]["status"], label="Control")
kmf.plot(ci_show=True, color="#56B4E9", linestyle='-', linewidth=2)

plt.axvline(x=kmf.median_, color='black', linestyle='--', linewidth=1)

plt.title("Kaplan-Meier Survival Curves", fontsize=16)
plt.xlabel("Time in days", fontsize=14)
plt.ylabel("Survival Probability", fontsize=14)
plt.xlim(0, 35)
plt.xticks(np.arange(0, 36, 5))
plt.grid(True, which="both", linestyle='--', linewidth=0.5, color="#dbe3db")

plt.show()
