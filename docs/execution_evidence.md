# Execution Evidence

This document records the key execution and validation results from the
Healthcare Data Warehouse & Analytics Pipeline.

## 1. Source Dataset

Dataset: HLT-002 Synthetic EHR sample

Records:
- 4,177 encounters
- 500 distinct patients
- 102 source columns
- 101 columns after removing the completely empty hir_bundle_path column

The dataset is synthetic and contains no real patient information.

---

## 2. Python Data Validation

The source dataset was validated before loading into Snowflake.

| Validation | Result |
|---|---|
| Required columns | PASS |
| Required values | PASS |
| Duplicate encounter IDs | PASS |
| Missing encounter IDs | PASS |
| Missing patient IDs | PASS |
| Missing encounter dates | PASS |
| Invalid dates | PASS |
| Discharge before encounter | PASS |
| Secondary diagnosis consistency | PASS |
| Length-of-stay consistency | PASS |
| Numeric validation rules | PASS |
| Categorical validation rules | PASS |

Validation summary:

- Duplicate encounter IDs: 0
- Missing encounter IDs: 0
- Missing patient IDs: 0
- Invalid encounter dates: 0
- Discharge dates before encounter dates: 0
- Numeric validation failures: 0
- Categorical validation failures: 0

---

## 3. Snowflake Warehouse

The validated dataset was loaded into Snowflake.

Database:

HEALTHCARE_DB

Schemas:

- RAW
- STAGING
- ANALYTICS

RAW table:

RAW.EHR_ENCOUNTERS

Load result:

- Rows loaded: 4,177
- Distinct encounter IDs: 4,177

The RAW layer preserves the source representation, while type casting and
warehouse transformations are handled downstream by dbt.

---

## 4. dbt Transformation

dbt was used to transform the RAW Snowflake data into staging, dimensions,
facts, and analytical marts.

### Staging

- stg_ehr_encounters

### Dimensions

- dim_patient
- dim_date

### Fact

- act_encounter

### Analytical Marts

- mart_encounter_summary
- mart_patient_utilization
- mart_clinical_metrics

---

## 5. dbt Testing

The complete dbt project was validated using:

dbt build

Execution result:

| Status | Count |
|---|---:|
| PASS | 26 |
| WARN | 0 |
| ERROR | 0 |
| SKIP | 0 |
| NO-OP | 0 |
| REUSED | 0 |
| TOTAL | 26 |

All 26 dbt tests passed during project execution.

---

## 6. Power BI

The curated Snowflake/dbt marts were connected to Power BI Desktop.

Three dashboard pages were developed:

1. Healthcare Overview
2. Patient Utilization
3. Clinical Metrics

Dashboard screenshots are available in:

dashboard/screenshots/

The Power BI .pbix file is intentionally excluded from Git because the
repository is designed to contain the reproducible data-engineering code,
SQL, dbt models, documentation, and dashboard evidence rather than local
desktop application files.

---

## 7. Key Warehouse Results

| Metric | Result |
|---|---:|
| Total encounters | 4,177 |
| Total patients | 500 |
| Average LOS | 0.83 days |
| Emergency encounters | 638 |
| Average encounters per patient | 8.35 |
| Repeat patients | 499 |
| Average SpO2 | 95.78 |
| Average glucose | 110.93 |
| Average creatinine | 1.12 |

---

## 8. Reproducibility

The repository contains the Python ingestion and validation scripts, dbt
models and tests, SQL analytics queries, notebooks, requirements, and
dashboard screenshots.

Sensitive credentials, local datasets, Power BI project files, and generated
dbt artifacts are excluded through .gitignore.
