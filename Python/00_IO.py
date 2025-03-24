import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import json
import openpyxl

# Write/Read table TSV
data.to_csv('data.tsv', sep='\t', index=False, quoting=3)  # quoting=3 prevents quotes around strings
data = pd.read_csv('data.tsv', sep='\t')

# Write/Read table CSV
data.to_csv('data.csv', index=False, quoting=3)
data = pd.read_csv('data.csv')

# Write/Read Excel file
data.to_excel('data.xlsx', index=False)
data = pd.read_excel('data.xlsx')

# Write/Read JSON file
data.to_json('data.json', orient='records', lines=True)
with open('data.json') as f:
    data = pd.read_json(f)

# Read Delim (txt file with tab-separated values)
data = pd.read_csv('data.txt', sep='\t', header=0, na_values="NA")

# Save plot to PDF file
# Example plot
plt.figure(figsize=(6,4))
sns.scatterplot(data=data, x='x', y='y', alpha=1.2, size=3)

plt.savefig("data.pdf", format="pdf")

# Arrange plots in a grid
from matplotlib import gridspec

fig = plt.figure(figsize=(10, 8))
gs = gridspec.GridSpec(2, 2, figure=fig)

# Example plots
p1 = fig.add_subplot(gs[0, 0])
sns.scatterplot(data=data, x='x', y='y', ax=p1)

p2 = fig.add_subplot(gs[0, 1])
sns.scatterplot(data=data, x='x', y='y', ax=p2)

p3 = fig.add_subplot(gs[1, 0])
sns.scatterplot(data=data, x='x', y='y', ax=p3)

p4 = fig.add_subplot(gs[1, 1])
sns.scatterplot(data=data, x='x', y='y', ax=p4)

# Save the grid as a PDF
plt.savefig("grid_plot.pdf", format="pdf")
