import numpy as np
import pandas as pd
import statsmodels.api as sm

# Simulate data (100 samples, 1000 genes)
np.random.seed(123)
n_samples = 100
n_genes = 1000

# Simulate gene expression data (features)
X = np.random.randn(n_samples, n_genes)
gene_names = [f"Gene{i}" for i in range(1, n_genes + 1)]

# True genes and coefficients (only using the first 3 genes for simplicity)
true_genes = ["Gene1", "Gene2", "Gene3"]
beta_true = np.array([1.5, -1.0, 0.8])

# Linear predictor
linear_predictor = np.dot(X[:, :3], beta_true)

# Simulate survival times using exponential distribution
baseline_hazard = 0.1
surv_time = np.random.exponential(scale=1 / (baseline_hazard * np.exp(linear_predictor)))
event_status = np.random.binomial(1, 0.5, size=n_samples)

# Create DataFrame for features
data = pd.DataFrame(X, columns=gene_names)
data['time'] = surv_time
data['status'] = event_status

# Separate predictors (X) and target (y)
X = data[gene_names]
y = data['time']

# Convert all feature columns to numeric (if needed)
X = X.apply(pd.to_numeric, errors='coerce')
y = pd.to_numeric(y, errors='coerce')

# Handle missing data (drop rows with NaN values)
X = X.dropna()
y = y[X.index]  # Align y with X after dropping rows

# Add a constant (intercept) to the model
X = sm.add_constant(X)

# Fit the OLS model
try:
    model = sm.OLS(y, X).fit()
    # Print the summary of the model
    print(model.summary())
except Exception as e:
    print(f"Error fitting model: {e}")
