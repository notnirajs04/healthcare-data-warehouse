# Healthcare Data Warehouse & Analytics Pipeline

An end-to-end healthcare data engineering project that transforms synthetic Electronic Health Record (EHR) encounter data into a validated Snowflake data warehouse, dbt analytical models, SQL insights, and an interactive Power BI dashboard.

---

## Project Overview

This project demonstrates an end-to-end data engineering workflow for healthcare encounter analytics.

The pipeline takes synthetic EHR encounter data through:

**Python → Snowflake → dbt → SQL → Power BI**

The project covers:

- Data ingestion
- Data profiling
- Data validation
- Data cleaning
- Cloud data warehousing
- Dimensional modeling
- dbt transformations
- Data quality testing
- Analytical SQL
- Power BI dashboard development

The objective is to transform raw healthcare encounter data into reliable, structured, and analytics-ready datasets.

> **Data Privacy:** This project uses synthetic, non-identifiable healthcare data and does not contain real patient records.

---

## Architecture

```text
                    ┌──────────────────────┐
                    │  Synthetic EHR Data  │
                    │        CSV           │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │        Python        │
                    │                      │
                    │  Extract             │
                    │  Validate            │
                    │  Transform           │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │      Snowflake       │
                    │                      │
                    │         RAW          │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │         dbt          │
                    │                      │
                    │      STAGING         │
                    │         ↓            │
                    │ Dimensions + Fact    │
                    │         ↓            │
                    │   Analytics Marts    │
                    └──────────┬───────────┘
                               │
                     ┌─────────┴─────────┐
                     │                   │
                     ▼                   ▼
              ┌──────────────┐    ┌──────────────┐
              │ SQL Analysis │    │   Power BI   │
              │              │    │  Dashboard   │
              └──────────────┘    └──────────────┘
```

---

## Technology Stack

| Technology | Purpose |
|---|---|
| **Python** | Data extraction, validation, and transformation |
| **Pandas** | Data profiling and preprocessing |
| **Snowflake** | Cloud data warehouse |
| **SQL** | Analytical queries |
| **dbt** | Data transformation, modeling, and testing |
| **Power BI** | Dashboard and data visualization |
| **Jupyter Notebook** | Data exploration and validation |
| **Git / GitHub** | Version control |

---

## Dataset

The project uses the **HLT-002 Synthetic EHR Sample**.

The dataset contains synthetic, non-identifiable healthcare encounter information and is used for educational and portfolio purposes.

### Dataset Summary

| Attribute | Value |
|---|---:|
| Healthcare encounters | **4,177** |
| Unique patients | **500** |
| Source columns | **102** |
| Columns after cleaning | **101** |
| Encounter date range | **2020–2024** |

### Dataset Contains

- Patient demographics
- Encounter information
- Encounter types
- Primary and secondary diagnoses
- Medication counts
- Vital signs
- Laboratory measurements
- Insurance information
- Facility information
- Length of stay

### Dataset Source

**HLT-002 Synthetic EHR Sample**

Source: `xpertsystems/hlt002-sample` on Hugging Face

> The dataset is synthetic and non-identifiable. No real patient records are used in this project.

---

## Data Engineering Pipeline

```text
Raw Dataset
     ↓
Data Exploration
     ↓
Python Validation
     ↓
Python Transformation
     ↓
Snowflake RAW
     ↓
dbt STAGING
     ↓
Dimensional Model
     ↓
Analytics Marts
     ↓
SQL Analytics
     ↓
Power BI Dashboard
```

---

# 1. Data Exploration & Profiling

Initial data exploration was performed using Jupyter notebooks.

The dataset was profiled for:

- Dataset dimensions
- Data types
- Missing values
- Duplicate records
- Duplicate encounter IDs
- Duplicate patient IDs
- Numeric distributions
- Categorical distributions
- Date validity
- Clinical measurement ranges

### Initial Dataset

```text
Rows    : 4,177
Columns : 102
```

A completely empty source column, `fhir_bundle_path`, was identified during profiling and removed during transformation.

### Processed Dataset

```text
Rows    : 4,177
Columns : 101
```

The original raw dataset was preserved separately from the processed dataset.

---

# 2. Python Data Ingestion

The Python ingestion layer is located in:

```text
ingestion/
├── extract.py
├── validate.py
└── transform.py
```

## Extraction

`extract.py`

The extraction process:

- Checks whether the raw dataset exists
- Loads the CSV using Pandas
- Reports the number of records and columns

## Validation

`validate.py`

The validation process checks:

- Required columns
- Missing encounter IDs
- Missing patient IDs
- Missing encounter dates
- Duplicate encounter IDs
- Invalid encounter dates
- Discharge dates occurring before encounter dates

Additional notebook-based validation checks include:

- Secondary diagnosis consistency
- Length-of-stay consistency
- Numeric range validation
- Categorical validation
- Vital-sign validation

## Transformation

`transform.py`

The transformation process performs:

- Column-name standardization
- Date conversion
- Text standardization
- Removal of completely empty source columns

The cleaned dataset is written separately from the original raw dataset.

---

# 3. Data Quality Results

The source data passed the validation checks performed during the project.

| Validation | Result |
|---|---:|
| Total encounters | **4,177** |
| Duplicate encounter IDs | **0** |
| Missing encounter IDs | **0** |
| Missing patient IDs | **0** |
| Invalid encounter dates | **0** |
| Discharge before encounter | **0** |
| Secondary diagnosis mismatches | **0** |
| LOS mismatches | **0** |
| Numeric validation failures | **0** |
| Categorical validation failures | **0** |

---

# 4. Snowflake Data Warehouse

Snowflake is used as the cloud data warehouse for the project.

## Database

```text
HEALTHCARE_DB
```

## Schema Architecture

```text
HEALTHCARE_DB
│
├── RAW
├── STAGING
└── ANALYTICS
```

### RAW Layer

The source data is loaded into:

```text
RAW.EHR_ENCOUNTERS
```

The RAW table preserves the source representation before type conversion and transformation.

A Snowflake internal stage is used to load the processed CSV into the RAW table.

---

# 5. dbt Transformation Layer

The dbt project is located inside:

```text
dbt_healthcare/
```

dbt is used to transform the Snowflake RAW data into structured and analytics-ready models.

The transformation flow is:

```text
RAW
  ↓
STAGING
  ↓
DIMENSIONS + FACT
  ↓
ANALYTICS MARTS
```

## Staging Model

### `STG_EHR_ENCOUNTERS`

The staging model converts raw source values into appropriate Snowflake data types.

Transformations include:

- Date conversion
- Numeric conversion
- Boolean conversion
- Clinical measurement conversion

Snowflake `TRY_TO_*` functions are used for safe type conversion.

---

# 6. Dimensional Data Model

The project uses a dimensional modeling approach.

## `DIM_PATIENT`

**Grain:** One row per patient

Contains:

- Patient ID
- Age
- Age band
- Sex
- Race/ethnicity
- Insurance type
- PCP flag
- State

**Result:** 500 patients

---

## `DIM_DATE`

**Grain:** One row per calendar date

Contains:

- Date key
- Full date
- Year
- Quarter
- Month
- Month name
- Week
- Day
- Weekend indicator

**Date range:**

```text
2020-01-01 → 2024-12-31
```

---

## `FACT_ENCOUNTER`

**Grain:** One row per healthcare encounter

Contains:

- Encounter identifiers
- Patient key
- Encounter date key
- Encounter type
- Diagnosis information
- Medication counts
- Facility information
- Demographics
- Vital signs
- Laboratory measurements

**Result:** 4,177 encounters

---

# 7. Analytics Marts

Three analytical marts were created for downstream analytics.

## `MART_ENCOUNTER_SUMMARY`

Used for encounter and monthly analysis.

Includes:

- Encounter count
- Average length of stay
- Average patient age
- Average SpO₂
- Average glucose
- Average creatinine
- Average medications
- Average secondary diagnoses

---

## `MART_PATIENT_UTILIZATION`

**Grain:** One row per patient

Used for patient utilization analysis.

Includes:

- Total encounters
- First encounter
- Last encounter
- Average LOS
- Maximum LOS
- Emergency encounters
- Inpatient encounters
- Outpatient encounters
- Telehealth encounters
- Average medications
- Average secondary diagnoses
- Patient demographics
- Insurance type

---

## `MART_CLINICAL_METRICS`

**Grain:** One row per encounter

Used for clinical analytics.

Includes:

- Encounter information
- Patient information
- Vital signs
- Laboratory measurements
- Demographics
- Insurance information

---

# 8. dbt Data Quality Testing

dbt tests were implemented for important keys and relationships.

Tests include:

- `not_null`
- `unique`
- `relationships`

Examples include validation of:

- Encounter IDs
- Patient IDs
- Patient keys
- Date keys
- Fact-table keys
- Patient relationships
- Date relationships

## Final dbt Build

The complete dbt project was successfully built and tested.

```text
PASS     = 26
WARN     = 0
ERROR    = 0
SKIP     = 0
NO-OP    = 0
REUSED   = 0
TOTAL    = 26
```

---

# 9. SQL Analytics

Analytical SQL queries are stored in:

```text
sql/
├── 01_encounter_analysis.sql
├── 02_patient_utilization.sql
├── 03_clinical_metrics.sql
└── 04_facility_analysis.sql
```

## Encounter Analysis

`01_encounter_analysis.sql`

Includes:

- Encounter type distribution
- Monthly encounter volume
- Average and maximum LOS
- Encounters by insurance
- Emergency utilization
- Inpatient utilization
- Outpatient utilization
- Telehealth utilization

## Patient Utilization

`02_patient_utilization.sql`

Includes:

- Top patients by encounter count
- Average encounters by insurance
- Utilization by age band
- Emergency utilization
- Repeat patient analysis

## Clinical Metrics

`03_clinical_metrics.sql`

Includes:

- Average vital signs
- Laboratory averages
- BMI by age band
- Monthly average SpO₂
- Clinical metrics by insurance

## Facility Analysis

`04_facility_analysis.sql`

Includes:

- Encounters by facility type
- Average LOS by facility type
- Encounters by state
- Facility type by encounter type
- Clinical metrics by facility type
- Insurance distribution by facility type

---

# 10. Power BI Dashboard

The final Power BI dashboard contains three analytical pages.

## Page 1 — Healthcare Overview

### KPI Cards

- Total Encounters
- Total Patients
- Average LOS
- Emergency Encounters

### Visualizations

- Monthly Encounter Trend
- Encounters by Type
- Encounters by Insurance Type

---

## Page 2 — Patient Utilization

### KPI Cards

- Average Encounters per Patient
- Repeat Patients

### Visualizations

- Encounters by Age Band
- Emergency Encounters by Age Band
- Encounters by Insurance Type
- Average LOS by Insurance Type
- Top 10 Patients by Encounter Count

---

## Page 3 — Clinical Metrics

### KPI Cards

- Average SpO₂
- Average Glucose
- Average Creatinine

### Visualizations

- Average Heart Rate by Encounter Type
- Average Systolic Blood Pressure by Encounter Type
- Average BMI by Age Band
- Monthly Average SpO₂ Trend

---

# 11. Dashboard Screenshots

Add the exported Power BI screenshots to:

```text
dashboard/
├── healthcare_overview.png
├── patient_utilization.png
└── clinical_metrics.png
```

Then display them in GitHub using:

### Healthcare Overview

![Healthcare Overview](dashboard/healthcare_overview.png)

### Patient Utilization

![Patient Utilization](dashboard/patient_utilization.png)

### Clinical Metrics

![Clinical Metrics](dashboard/clinical_metrics.png)

---

# 12. Project Structure

```text
Healthcare/
│
├── dashboard/
│
├── data/
│   ├── raw/
│   └── processed/
│
├── dbt_healthcare/
│   └── dbt_healthcare/
│       ├── models/
│       │   ├── staging/
│       │   ├── dimensions/
│       │   └── marts/
│       ├── dbt_project.yml
│       └── ...
│
├── ingestion/
│   ├── extract.py
│   ├── validate.py
│   └── transform.py
│
├── logs/
│
├── notebooks/
│   ├── 01_exploration.ipynb
│   └── 02_validation_testing.ipynb
│
├── sql/
│   ├── 01_encounter_analysis.sql
│   ├── 02_patient_utilization.sql
│   ├── 03_clinical_metrics.sql
│   └── 04_facility_analysis.sql
│
├── .gitignore
├── README.md
└── requirements.txt
```

---

# 13. How to Run

## 1. Clone the repository

```bash
git clone <YOUR-GITHUB-REPOSITORY-URL>
cd Healthcare
```

## 2. Create the Python environment

```bash
conda create -n healthcare-de python=3.11
conda activate healthcare-de
```

## 3. Install dependencies

```bash
pip install -r requirements.txt
```

## 4. Add the dataset

Place the dataset at:

```text
data/raw/ehr_encounters.csv
```

## 5. Run extraction

```bash
python ingestion/extract.py
```

## 6. Run transformation

```bash
python ingestion/transform.py
```

The processed dataset will be generated at:

```text
data/processed/ehr_encounters_clean.csv
```

## 7. Configure Snowflake

Create the following database and schemas:

```text
HEALTHCARE_DB
├── RAW
├── STAGING
└── ANALYTICS
```

Load the processed dataset into:

```text
RAW.EHR_ENCOUNTERS
```

## 8. Configure dbt

Configure a local dbt profile with your own Snowflake credentials.

Do **not** commit credentials or `profiles.yml` to GitHub.

Run:

```bash
dbt debug
```

Then:

```bash
dbt build
```

Expected result:

```text
PASS=26
WARN=0
ERROR=0
SKIP=0
```

## 9. Power BI

Connect Power BI to the curated Snowflake analytical models and build the dashboard using the analytics marts.

---

# 14. Key Engineering Concepts Demonstrated

This project demonstrates practical implementation of:

- ETL / ELT pipeline design
- Data ingestion
- Data profiling
- Data validation
- Data cleaning
- Cloud data warehousing
- Snowflake
- SQL
- dbt
- Dimensional modeling
- Fact and dimension tables
- Data marts
- Data quality testing
- Analytical SQL
- Business intelligence
- Power BI
- Git / GitHub

---

# 15. Key Project Results

| Metric | Result |
|---|---:|
| Healthcare encounters | **4,177** |
| Unique patients | **500** |
| Columns after cleaning | **101** |
| Duplicate encounter IDs | **0** |
| Invalid encounter dates | **0** |
| LOS inconsistencies | **0** |
| dbt checks passed | **26** |
| dbt errors | **0** |

The completed pipeline transforms raw synthetic healthcare data into validated, tested, and analytics-ready datasets that can be consumed through SQL and Power BI.

---

# 16. Data Privacy

This project uses synthetic, non-identifiable healthcare data for educational and portfolio purposes.

No real patient medical records or personally identifiable healthcare information are used.

---

# Author

**Niraj S.**

MCA — Artificial Intelligence and Data Science

---

## Disclaimer

This project is intended for educational and portfolio purposes. The synthetic dataset does not represent real patients or real clinical records.
