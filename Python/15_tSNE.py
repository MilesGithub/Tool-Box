import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.manifold import TSNE
from sklearn.preprocessing import StandardScaler
import seaborn as sns

# Parameters
n_genes = 1000
n_samples = 100
genes = [f"Gene{i+1}" for i in range(n_genes)]
samples = [f"Sample{i+1}" for i in range(n_samples)]
group = ["Control"] * 50 + ["Treatment"] * 50  # Control and Treatment groups

# Simulate expression:
# Control: baseline expression
control_expr = np.random.normal(loc=10, scale=1, size=(n_genes, 50))

# Treatment: upregulate first 200 genes by 0.5
treatment_expr = np.random.normal(loc=10, scale=1, size=(n_genes, 50))
treatment_expr[:200, :] += 0.5

expr_matrix = np.hstack([control_expr, treatment_expr])
expr_matrix = pd.DataFrame(expr_matrix, index=genes, columns=samples)

# Transpose the matrix to match samples as rows
expr_t = expr_matrix.T

# Standardize the expression data
scaler = StandardScaler()
expr_t_scaled = scaler.fit_transform(expr_t)

# Run t-SNE
tsne = TSNE(n_components=2, init='pca', random_state=42)
tsne_results = tsne.fit_transform(expr_t_scaled)

# Create a DataFrame for t-SNE results
tsne_df = pd.DataFrame(tsne_results, columns=["tSNE1", "tSNE2"])
tsne_df['Group'] = group

# Custom color vector: named by group
custom_colors = {"Control": "#1f77b4", "Treatment": "#ff7f0e"}  # blue and orange

# t-SNE Plot
plt.figure(figsize=(8, 6))
sns.scatterplot(data=tsne_df, x="tSNE1", y="tSNE2", hue="Group", palette=custom_colors, s=100, alpha=0.85)

plt.title("t-SNE of Simulated Gene Expression (100 Samples)")
plt.xlabel("t-SNE Dimension 1")
plt.ylabel("t-SNE Dimension 2")
plt.legend(title="Group", loc="upper right")
plt.grid(True, linestyle='--', linewidth=0.5, color='#dbe3db')
plt.show()
