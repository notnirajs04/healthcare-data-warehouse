from pathlib import Path

import pandas as pd


RAW_DATA_PATH = Path("data/raw/ehr_encounters.csv")
PROCESSED_DATA_PATH = Path("data/processed/ehr_encounters_clean.csv")


def load_raw_data() -> pd.DataFrame:
    """
    Load the raw healthcare encounter dataset.
    """
    if not RAW_DATA_PATH.exists():
        raise FileNotFoundError(
            f"Raw dataset not found: {RAW_DATA_PATH}"
        )

    return pd.read_csv(RAW_DATA_PATH)


def standardize_column_names(df: pd.DataFrame) -> pd.DataFrame:
    """
    Convert column names to lowercase snake_case.
    """
    data = df.copy()

    data.columns = (
        data.columns
        .str.strip()
        .str.lower()
        .str.replace(" ", "_")
    )

    return data


def standardize_dates(df: pd.DataFrame) -> pd.DataFrame:
    """
    Convert date columns to pandas datetime format.
    """
    data = df.copy()

    date_columns = [
        "encounter_date",
        "discharge_date"
    ]

    for column in date_columns:
        data[column] = pd.to_datetime(
            data[column],
            errors="coerce"
        )

    return data


def standardize_text_columns(df: pd.DataFrame) -> pd.DataFrame:
    """
    Remove unnecessary whitespace from text columns.
    """
    data = df.copy()

    text_columns = data.select_dtypes(
        include=["object", "string"]
    ).columns

    for column in text_columns:
        data[column] = data[column].apply(
            lambda value: value.strip()
            if isinstance(value, str)
            else value
        )

    return data


def remove_empty_source_columns(df: pd.DataFrame) -> pd.DataFrame:
    """
    Remove columns that contain no usable values.

    The original raw dataset is never modified.
    """
    data = df.copy()

    empty_columns = [
        column
        for column in data.columns
        if data[column].isna().all()
    ]

    if empty_columns:
        print(
            "Removing completely empty columns:",
            empty_columns
        )

        data = data.drop(columns=empty_columns)

    return data


def transform_data(df: pd.DataFrame) -> pd.DataFrame:
    """
    Apply all transformations in sequence.
    """
    data = standardize_column_names(df)
    data = standardize_dates(data)
    data = standardize_text_columns(data)
    data = remove_empty_source_columns(data)

    return data


def save_processed_data(df: pd.DataFrame) -> None:
    """
    Save the transformed dataset.
    """
    PROCESSED_DATA_PATH.parent.mkdir(
        parents=True,
        exist_ok=True
    )

    df.to_csv(
        PROCESSED_DATA_PATH,
        index=False
    )

    print(
        f"Processed dataset saved to: "
        f"{PROCESSED_DATA_PATH}"
    )


if __name__ == "__main__":
    raw_df = load_raw_data()

    transformed_df = transform_data(raw_df)

    print(
        f"Input shape: {raw_df.shape}"
    )

    print(
        f"Output shape: {transformed_df.shape}"
    )

    save_processed_data(transformed_df)