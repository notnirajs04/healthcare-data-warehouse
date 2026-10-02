import pandas as pd


REQUIRED_COLUMNS = [
    "encounter_id",
    "patient_id",
    "encounter_date",
]


def validate_required_columns(df: pd.DataFrame) -> list[str]:
    """
    Check whether all required columns are present.
    """

    missing_columns = [
        column
        for column in REQUIRED_COLUMNS
        if column not in df.columns
    ]

    return missing_columns


def validate_required_values(df: pd.DataFrame) -> pd.DataFrame:
    """
    Identify records with missing required fields.
    """

    invalid = df[
        df["encounter_id"].isna()
        | df["patient_id"].isna()
        | df["encounter_date"].isna()
    ].copy()

    return invalid


def validate_encounter_ids(df: pd.DataFrame) -> pd.DataFrame:
    """
    Identify records with duplicate encounter IDs.
    """

    invalid = df[
        df["encounter_id"].duplicated(keep=False)
    ].copy()

    return invalid


def validate_dates(df: pd.DataFrame) -> pd.DataFrame:
    """
    Validate encounter and discharge dates.
    """

    data = df.copy()

    data["encounter_date"] = pd.to_datetime(
        data["encounter_date"],
        errors="coerce"
    )

    data["discharge_date"] = pd.to_datetime(
        data["discharge_date"],
        errors="coerce"
    )

    invalid = data[
        data["encounter_date"].isna()
        |
        (
            data["discharge_date"].notna()
            &
            (
                data["discharge_date"]
                < data["encounter_date"]
            )
        )
    ].copy()

    return invalid