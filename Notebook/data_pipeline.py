"""
data_pipeline.py

Reusable pipeline for loading, cleaning, and loading NHS PCA (Prescription
Cost Analysis) monthly CSVs into a SQLite database.

Run from the Notebook/ folder (same location as nhs_prescription_analysis.ipynb),
either directly:

    python data_pipeline.py

or imported into the notebook:

    from data_pipeline import load_and_combine_csvs, clean_prescriptions, load_to_sqlite

    df = load_and_combine_csvs()
    df_clean = clean_prescriptions(df)
    load_to_sqlite(df_clean)
"""

import pandas as pd
import glob
import sqlite3


def load_and_combine_csvs(folder_path="../Data/*.csv"):
    """Load and concatenate all monthly NHS PCA CSVs into one dataframe.

    Args:
        folder_path: glob pattern matching the monthly CSV files, relative
            to the Notebook/ folder. Defaults to "../Data/*.csv" (i.e. the
            Data/ folder one level up from Notebook/). Note the capital "D" —
            this matters on case-sensitive filesystems (Linux/some macOS
            setups), even though it's invisible on Windows.

    Returns:
        A single concatenated DataFrame of all matched files.

    Raises:
        FileNotFoundError: if no files match folder_path.
    """
    files = sorted(glob.glob(folder_path))
    if not files:
        raise FileNotFoundError(
            f"No CSV files found matching '{folder_path}'. "
            "Check that you're running from the Notebook/ folder, or update the path."
        )
    df_list = [pd.read_csv(f) for f in files]
    return pd.concat(df_list, ignore_index=True)


def clean_prescriptions(df):
    """Apply the full cleaning pipeline: drop cols, handle NAs, fix types, dedupe.

    Args:
        df: raw combined DataFrame from load_and_combine_csvs().

    Returns:
        Cleaned DataFrame.
    """
    columns_to_drop = [
        "REGION_CODE", "ICB_CODE", "BNF_PRESENTATION_CODE", "SNOMED_CODE",
        "SUPPLIER_NAME", "GENERIC_BNF_EQUIVALENT_CODE", "BNF_CHEMICAL_SUBSTANCE_CODE",
        "BNF_PARAGRAPH_CODE", "BNF_SECTION_CODE", "BNF_CHAPTER_CODE",
        "PREP_CLASS", "PRESCRIBED_PREP_CLASS", "PHARMACY_ADVANCED_SERVICE"
    ]
    df_clean = df.drop(columns=columns_to_drop, errors="ignore")
    df_clean = df_clean.dropna(subset=["GENERIC_BNF_EQUIVALENT_NAME"])
    df_clean["YEAR_MONTH"] = pd.to_datetime(df_clean["YEAR_MONTH"].astype(str), format="%Y%m")
    df_clean["YEAR_MONTH"] = df_clean["YEAR_MONTH"].dt.strftime("%Y-%m")
    df_clean = df_clean.drop_duplicates()
    return df_clean


def load_to_sqlite(df_clean, db_path="../Data/nhs_prescriptions.db", table_name="prescriptions"):
    """Write the cleaned dataframe to SQLite and add performance indexes.

    Args:
        df_clean: cleaned DataFrame from clean_prescriptions().
        db_path: path to the SQLite database file to create/overwrite,
            relative to the Notebook/ folder.
        table_name: name of the table to write to.
    """
    conn = sqlite3.connect(db_path)
    try:
        df_clean.to_sql(table_name, conn, if_exists="replace", index=False)
        conn.execute(f"CREATE INDEX IF NOT EXISTS idx_region ON {table_name}(REGION_NAME);")
        conn.execute(f"CREATE INDEX IF NOT EXISTS idx_medicine ON {table_name}(BNF_PRESENTATION_NAME);")
        conn.execute(f"CREATE INDEX IF NOT EXISTS idx_yearmonth ON {table_name}(YEAR_MONTH);")
        conn.commit()
    finally:
        conn.close()


if __name__ == "__main__":
    # Allows running the whole pipeline directly with: python data_pipeline.py
    df = load_and_combine_csvs()
    df_clean = clean_prescriptions(df)
    load_to_sqlite(df_clean)
    print(f"Done. {len(df_clean)} rows loaded into ../Data/nhs_prescriptions.db")
