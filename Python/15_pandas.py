# 1. Import pandas and numpy (for random data generation)
import pandas as pd
import numpy as np

# --- Define Trial Specifics ---
treatments = ['Test Small Molecule 01', 'Test Monoclonal Antibody 01', 'Test Vaccine 01', 'Placebo']
sites = ['Princess Margaret Cancer Centre', 'Memorial Sloan Kettering', 'MD Anderson Cancer Center']
num_participants = 20

# --- 2. Create Sample Clinical Trial Data ---
np.random.seed(42)
data = {
    'ParticipantID': [f'PT-{i:03d}' for i in range(1, num_participants + 1)],
    'Treatment': np.random.choice(treatments, num_participants),
    'Site': np.random.choice(sites, num_participants),
    'Age': np.random.randint(35, 75, size=num_participants),
    'Sex': np.random.choice(['Male', 'Female'], num_participants, p=[0.5, 0.5]),
    'BaselineSeverity': np.random.normal(loc=60, scale=15, size=num_participants).clip(20, 100).astype(int),
    'AdverseEvent': np.random.choice([False, True], num_participants, p=[0.85, 0.15])
}

# Create DataFrame
df = pd.DataFrame(data)

# Simulate FollowUpSeverity based on Treatment
reduction_factor = np.random.normal(loc=0.5, scale=0.1, size=num_participants)
reduction_factor[df['Treatment'] == 'Placebo'] = np.random.normal(loc=0.15, scale=0.05, size=(df['Treatment'] == 'Placebo').sum())
df['FollowUpSeverity'] = (df['BaselineSeverity'] * (1 - reduction_factor) + np.random.normal(0, 5, num_participants)).clip(0, 100).astype(int)


# --- 3. View Basic Information ---
print("--- Clinical Trial DataFrame ---")
print(df.head())


print("--- DataFrame Info (Data Types, Non-Null Counts) ---")
df.info()


print("--- Descriptive Statistics (Age, Scores) ---")
print(df[['Age', 'BaselineSeverity', 'FollowUpSeverity']].describe())


# --- 4. Select Specific Data ---
print("--- Selecting 'Treatment' assignments ---")
print(df['Treatment'].value_counts())


print("--- Selecting Participants' Age and Sex ---")
print(df[['ParticipantID', 'Age', 'Sex']].head())


# Use .loc to select by ParticipantID
df_indexed = df.set_index('ParticipantID')
print("--- Selecting Data for Participant PT-005 using .loc ---")
try:
    print(df_indexed.loc['PT-005'])
except KeyError:
    print("Participant PT-005 not found.")


print("--- Selecting the first 3 participants' data using .iloc ---")
print(df.iloc[0:3])


# --- 5. Filtering Data ---
print("--- Filtering: Participants on 'Test Small Molecule 01' ---")
tsm01_group = df[df['Treatment'] == 'Test Small Molecule 01']
print(tsm01_group[['ParticipantID', 'Age', 'BaselineSeverity', 'FollowUpSeverity']])


# Using the current location context from the prompt
print(f"--- Filtering: Participants enrolled at 'Memorial Sloan Kettering' ---")
msk_participants = df[df['Site'] == 'Memorial Sloan Kettering']
print(msk_participants[['ParticipantID', 'Treatment', 'Age']])


print("--- Filtering: Participants who experienced an Adverse Event ---")
ae_participants = df[df['AdverseEvent'] == True]
print(ae_participants[['ParticipantID', 'Treatment', 'Site']])


# --- 6. Adding a Calculated Column ---
print("--- Adding 'SeverityChange' Column (Baseline - FollowUp) ---")
df['SeverityChange'] = df['BaselineSeverity'] - df['FollowUpSeverity']
print(df[['ParticipantID', 'Treatment', 'BaselineSeverity', 'FollowUpSeverity', 'SeverityChange']].head())


# --- 7. Grouping and Aggregation (Common Clinical Trial Analysis) ---
print("--- Average Severity Change per Treatment Group ---")
avg_change_per_treatment = df.groupby('Treatment')['SeverityChange'].mean().sort_values(ascending=False)
print(avg_change_per_treatment)


print("--- Count of Adverse Events per Treatment Group ---")
ae_counts = df[df['AdverseEvent'] == True].groupby('Treatment')['ParticipantID'].count()
ae_counts = ae_counts.reindex(treatments, fill_value=0)
print(ae_counts)


print("--- Participant Count per Site ---")
site_counts = df.groupby('Site')['ParticipantID'].count()
print(site_counts)


# Display shape of original DataFrame for comparison
print("--- Original DataFrame Shape ---")
print(f"Original df shape: {df.shape}")

# --- 8. Row Binding (like R's rbind) using pd.concat(axis=0) ---
print("--- 8a. Row Binding (rbind equivalent) ---")

new_participant_data = {
    'ParticipantID': ['PT-021', 'PT-022'],
    'Treatment': ['Test Vaccine 01', 'Placebo'],
    'Site': ['Guelph General', 'Toronto Central'], # Adding one in Guelph
    'Age': [55, 62],
    'Sex': ['Female', 'Male'],
    'BaselineSeverity': [70, 58],
    'AdverseEvent': [False, True],
    'FollowUpSeverity': [45, 55],
    'SeverityChange': [25, 3] # Calculated manually for this example
}
df_new_participants = pd.DataFrame(new_participant_data)

print("--- New Participant Data Shape ---")
print(f"New participants df shape: {df_new_participants.shape}")
print(df_new_participants)


# Concatenate the original df with the new participants row-wise
df_combined_rows = pd.concat([df, df_new_participants], ignore_index=True, sort=False)

print("--- Combined DataFrame (Rows Added) Shape and Tail ---")
print(f"Combined (rows) df shape: {df_combined_rows.shape}")
print("Tail of combined DataFrame (showing new rows):")
print(df_combined_rows.tail()) # Show the last few rows, including the new ones

# --- 9. Column Binding using pd.concat(axis=1) ---
print("--- 9a. Column Binding ---")

# Adding a single new column (Biomarker data) as a Pandas Series
# Ensure the Series index matches the DataFrame index (0 to num_participants-1 here)
biomarker_values = pd.Series(np.random.normal(10, 2, size=df.shape[0]), name='BiomarkerX') # df.shape[0] is original row count

print("--- New Biomarker Data (Series) ---")
print(f"Biomarker Series shape: ({len(biomarker_values)},)") # Series don't have a .shape tuple like DataFrames
print(biomarker_values.head())


# Adding multiple new columns as a new DataFrame
# Again, ensure the index matches the original df
extra_demographics_data = {
    'YearsSinceDiagnosis': np.random.randint(1, 10, size=df.shape[0]),
    'HasComorbidity': np.random.choice([True, False], size=df.shape[0], p=[0.4, 0.6])
}
df_extra_demo = pd.DataFrame(extra_demographics_data, index=df.index) # Match original index explicitly

print("--- New Demographics Data (DataFrame) ---")
print(f"Extra demographics df shape: {df_extra_demo.shape}")
print(df_extra_demo.head())

# Concatenate the original df with the new columns column-wise (axis=1)
# Pandas aligns based on the index.
df_combined_cols = pd.concat([df, biomarker_values, df_extra_demo], axis=1)

print("--- Combined DataFrame (Columns Added) Shape and Head ---")
print(f"Combined (columns) df shape: {df_combined_cols.shape}")
print("Head of combined DataFrame (showing new columns):")
print(df_combined_cols[['ParticipantID', 'Treatment', 'BiomarkerX', 'YearsSinceDiagnosis', 'HasComorbidity']].head())


# --- Alternative for adding columns: DataFrame.join() or assigning directly ---
df.join(df_extra_demo)
df['BiomarkerX'] = biomarker_values

# --- Display Final DataFrame ---
print("--- Final DataFrame with SeverityChange ---")
print(df)
