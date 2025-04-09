import numpy as np
import pandas as pd
from sklearn.decomposition import PCA
import matplotlib.pyplot as plt
import seaborn as sns

# Set seed
np.random.seed(42)

# Parameters
n_genes = 1000
n_samples = 100
genes = [f"Gene{i+1}" for i in range(n_genes)]
samples = [f"Sample{i+1}" for i in range(n_samples)]
group = np.array(["Control"] * 50 + ["Treatment"] * 50)

# Simulate expression
control_expr = np.random.normal(loc=10, scale=1, size=(n_genes, 50))
treatment_expr = np.random.normal(loc=10, scale=1, size=(n_genes, 50))
treatment_expr[:200, :] += 0.3  # Upregulate first 200 genes

# Combine and transpose (samples as rows)
expr_matrix = np.hstack([control_expr, treatment_expr])
expr_df = pd.DataFrame(expr_matrix.T, columns=genes, index=samples)

# Run PCA
pca = PCA(n_components=2)
pca_scores = pca.fit_transform(expr_df)

# Prepare plot data
pca_df = pd.DataFrame(pca_scores, columns=["PC1", "PC2"])
pca_df["Group"] = group

# Custom colors
custom_colors = {"Control": "#1f77b4", "Treatment": "#ff7f0e"}

# Plot
plt.figure(figsize=(10, 7))
sns.set(style="whitegrid")

sns.scatterplot(
    data=pca_df,
    x="PC1", y="PC2",
    hue="Group",
    palette=custom_colors,
    s=60,
    alpha=0.85,
    edgecolor="black"
)

plt.title("PCA of Simulated Gene Expression (100 Samples)", fontsize=16)
plt.xlabel(f"PC1 ({pca.explained_variance_ratio_[0] * 100:.1f}%)", fontsize=14)
plt.ylabel(f"PC2 ({pca.explained_variance_ratio_[1] * 100:.1f}%)", fontsize=14)
plt.xticks(fontsize=12)
plt.yticks(fontsize=12)
plt.gca().set_facecolor("#f2f2f2")
plt.gca().spines['top'].set_visible(False)
plt.gca().spines['right'].set_visible(False)
plt.grid(color="#dbe3db", linewidth=0.5)
plt.legend(title="", loc="upper right", frameon=False)
plt.tight_layout()
plt.show()
