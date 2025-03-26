import pandas as pd
import numpy as np
from scipy.stats import beta

def calculate_confidence_interval(successes, total, confidence=0.95):
    """
    Computes a Bayesian confidence interval for efficacy rate.
    Uses a Beta distribution (Beta-Binomial model).
    """
    alpha, beta_params = successes + 1, total - successes + 1
    lower_bound, upper_bound = beta.ppf([(1 - confidence) / 2, (1 + confidence) / 2], alpha, beta_params)
    return lower_bound, upper_bound

def classify_drug(efficacy):
    """
    Categorizes drugs based on efficacy rate.
    """
    if efficacy >= 0.8:
        return "High Efficacy"
    elif efficacy >= 0.5:
        return "Moderate Efficacy"
    else:
        return "Low Efficacy"

def process_clinical_trials(df):
    """
    Process clinical trial data with advanced analysis:
    - Normalize patient numbers
    - Compute efficacy rate
    - Estimate confidence intervals
    - Classify drugs based on efficacy
    """
    df.columns = [col.upper() for col in df.columns]
    
    # Filter only completed trials
    df = df[df["STATUS"] == "Completed"]
    
    # Compute Efficacy Rate
    df["EFFICACY_RATE"] = df["SUCCESSFUL_OUTCOMES"] / df["TOTAL_PATIENTS"]
    
    # Normalize total patients using Min-Max normalization
    df["NORMALIZED_PATIENTS"] = (df["TOTAL_PATIENTS"] - df["TOTAL_PATIENTS"].min()) / \
                                 (df["TOTAL_PATIENTS"].max() - df["TOTAL_PATIENTS"].min())
    
    # Compute confidence intervals for efficacy rate
    ci_bounds = df.apply(lambda row: calculate_confidence_interval(row["SUCCESSFUL_OUTCOMES"], row["TOTAL_PATIENTS"]), axis=1)
    df["CI_LOWER"], df["CI_UPPER"] = zip(*ci_bounds)
    
    # Classify drugs into efficacy categories
    df["EFFICACY_CATEGORY"] = df["EFFICACY_RATE"].apply(classify_drug)
    
    return df
