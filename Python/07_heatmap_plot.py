import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

np.random.seed(1)

n_genes = 15
n_samples = 10
gene_names = [f'Gene{i}' for i in range(1, n_genes + 1)]
sample_names = [f'Sample{i}' for i in range(1, n_samples + 1)]

# Generate random data
data = pd.DataFrame(np.random.randn(n_genes, n_samples),
                    index=gene_names,
                    columns=sample_names)

data.iloc[0:5, 5:10] += 2.5
data.iloc[5:10, 5:10] -= 2.5

print(data.iloc[:5, :5])

# --- Create Sample Annotation Data ---
sample_info = pd.DataFrame({
    'Condition': ['Control'] * 5 + ['Treatment'] * 5,
    'Batch': ['B1', 'B2'] * 5
}, index=sample_names)

print("\nSample Annotation Data:")
print(sample_info)

# --- Define colors for annotation levels ---
condition_palette = dict(Control="skyblue", Treatment="tomato")
batch_palette = dict(B1="grey", B2="lightgreen")

# --- Map annotation data to colors ---
condition_colors = sample_info['Condition'].map(condition_palette)
batch_colors = sample_info['Batch'].map(batch_palette)

col_colors_df = pd.DataFrame({'Condition': condition_colors, 'Batch': batch_colors})

# --- Generate Clustermap with Column Annotations ---
g = sns.clustermap(data,
                   cmap="vlag",
                   standard_scale=1,
                   col_colors=col_colors_df,
                   linewidths=0.1,
                   figsize=(10, 10)
                  )

g.fig.suptitle("Clustermap with Sample Annotations", y=1.03)

# --- Add a Legend for the Annotations ---
handles = [plt.Rectangle((0,0),1,1, color=color) for color in condition_palette.values()] + \
          [plt.Rectangle((0,0),1,1, color=color) for color in batch_palette.values()]
labels = list(condition_palette.keys()) + list(batch_palette.keys())

g.fig.legend(handles, labels, title='Annotations',
             bbox_to_anchor=(1.05, 0.9), # Position relative to figure
             loc='upper right', borderaxespad=0.)

plt.show()
