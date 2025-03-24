import numpy as np
import pandas as pd
from lifelines import CoxPHFitter

# Simulate data (100 samples, 100 genes)
np.random.seed(123)
n_samples = 100
n_genes = 1000

X = np.random.randn(n_samples, n_genes)
gene_names = [f"Gene{i}" for i in range(1, n_genes + 1)]

# True genes and coefficients
true_genes = ["Gene1", "Gene2", "Gene3"]
beta_true = np.array([1.5, -1.0, 0.8])

# Linear predictor
linear_predictor = np.dot(X[:, :3], beta_true)

# Simulate survival times using exponential distribution
baseline_hazard = 0.1
surv_time = np.random.exponential(scale=1/(baseline_hazard * np.exp(linear_predictor)))
event_status = np.random.binomial(1, 0.5, size=n_samples)

# Create survival dataframe
data = pd.DataFrame(X, columns=gene_names)
data['time'] = surv_time
data['status'] = event_status

# Reduce the number of features (for example, select the first 10 genes)
reduced_gene_names = gene_names[:10]
data_reduced = data[reduced_gene_names + ['time', 'status']]

# Fit the Cox Proportional Hazards model with regularization
cph = CoxPHFitter(penalizer=0.1)  # Adding penalizer for regularization

try:
    cph.fit(data_reduced, duration_col='time', event_col='status')
    print("Model fitted successfully!")
    cph.print_summary()  # Print summary of the model
except Exception as e:
    print(f"Error fitting model: {e}")
