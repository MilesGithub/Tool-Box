import unittest
import pandas as pd
from src.data_processor import process_clinical_trials

class TestDataProcessor(unittest.TestCase):
    def test_process_clinical_trials(self):
        data = {
            "trial_id": [101, 102, 103, 104],
            "drug_name": [
                "Test Small Molecule 01",
                "Test Small Molecule 02",
                "Test Monoclonal Antibody 01",
                "Test Monoclonal Antibody 02",
            ],
            "phase": ["Phase 3", "Phase 2", "Phase 3", "Phase 1"],
            "status": ["Completed", "Ongoing", "Completed", "Terminated"],
            "total_patients": [100, 80, 120, 50],
            "successful_outcomes": [85, 50, 90, 10],
        }
        df = pd.DataFrame(data)

        processed_df = process_clinical_trials(df)

        self.assertEqual(len(processed_df), 2)  # Only completed trials remain
        self.assertIn("EFFICACY_RATE", processed_df.columns)  # Efficacy rate column exists
        self.assertAlmostEqual(processed_df["EFFICACY_RATE"].iloc[0], 0.85, places=2)

if __name__ == "__main__":
    unittest.main()
