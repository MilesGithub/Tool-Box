import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from lifelines import CoxPHFitter

# Simulate data
np.random.seed(123)
df = pd.DataFrame({
    "time": np.random.exponential(scale=10, size=100),  # Simulated time-to-event data
    "status": np.random.choice([0, 1], size=100),  # Censoring indicator (0 = censored, 1 = event occurred)
    "age": np.random.normal(loc=60, scale=10, size=100),  # Simulated age
    "treatment": np.random.choice(["Yes", "No"], size=100),  # Treatment group
    "sex": np.random.choice(["Male", "Female"], size=100),  # Sex
    "bmi": np.random.normal(loc=25, scale=5, size=100)  # Simulated BMI values
})

# Encode categorical variables
df["treatment"] = df["treatment"].map({"Yes": 1, "No": 0})
df["sex"] = df["sex"].map({"Male": 1, "Female": 0})

# Fit the Cox proportional hazards model
cph = CoxPHFitter()
cph.fit(df, duration_col="time", event_col="status")

# Summary of the Cox model
summary_df = cph.summary

# Create a dataframe for hazard ratio plotting
hr_df = pd.DataFrame({
    "Predictor": summary_df.index,
    "HazardRatio": np.exp(summary_df["coef"]),
    "LowerCI": np.exp(summary_df["coef"] - 1.96 * summary_df["se(coef)"]),
    "UpperCI": np.exp(summary_df["coef"] + 1.96 * summary_df["se(coef)"])
})

hr_df = hr_df.sort_values(by="HazardRatio")

# Plot hazard ratios with confidence intervals
fig, ax = plt.subplots(figsize=(7, 5))

ax.hlines(hr_df["Predictor"], hr_df["LowerCI"], hr_df["UpperCI"], color="grey", linewidth=2)

ax.scatter(hr_df["HazardRatio"], hr_df["Predictor"], color="blue", s=50)

ax.axvline(x=1, linestyle="dashed", color="red", linewidth=1)

ax.set_xlabel("Hazard Ratio", fontsize=14)
ax.set_ylabel("")
ax.set_title("Hazard Ratios with 95% Confidence Intervals", fontsize=14)

ax.set_facecolor("#f2f2f2")
ax.grid(which="major", linestyle="-", linewidth=0.5, color="#dbe3db")
ax.spines["top"].set_visible(False)
ax.spines["right"].set_visible(False)
ax.spines["left"].set_visible(False)
ax.spines["bottom"].set_linewidth(0.5)

plt.show()
