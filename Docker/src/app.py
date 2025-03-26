import os
import logging
import pandas as pd
from data_processor import process_clinical_trials

log_file = os.getenv("LOG_FILE", "logs/app.log")
logging.basicConfig(filename=log_file, level=logging.INFO)

def main():
    logging.info("Starting pharmaceutical data processing...")

    input_file = "data/clinical_trials.csv"
    output_file = "data/processed_results.csv"

    try:
        df = pd.read_csv(input_file)
        processed_df = process_clinical_trials(df)
        processed_df.to_csv(output_file, index=False)
        logging.info("Data processing completed successfully.")
        print("Processing complete! Check 'data/processed_results.csv'.")
    except Exception as e:
        logging.error(f"Error processing data: {e}")
        print("An error occurred during processing.")

if __name__ == "__main__":
    main()
