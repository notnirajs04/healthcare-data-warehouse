from pathlib import Path
import pandas as pd

RAW_DATA_PATH = Path("data/raw/ehr_encounters.csv")


def extract_data() -> pd.DataFrame:
    """
    Load the raw healthcare encounter dataset.

    Returns:
        pd.DataFrame: Raw EHR encounter data.
    """
    if not RAW_DATA_PATH.exists():
        raise FileNotFoundError(
            f"Raw dataset not found: {RAW_DATA_PATH}"
        )

    df = pd.read_csv(RAW_DATA_PATH)

    print(f"Loaded {len(df):,} records with {len(df.columns)} columns.")

    return df


if __name__ == "__main__":
    extract_data()
