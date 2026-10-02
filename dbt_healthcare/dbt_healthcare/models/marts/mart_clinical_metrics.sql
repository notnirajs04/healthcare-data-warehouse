{{
    config(
        materialized='table'
    )
}}

-- ============================================================
-- MART_CLINICAL_METRICS
-- Grain: One row per healthcare encounter
-- Purpose: Clinical measurement analysis and reporting
-- ============================================================

SELECT

    -- Encounter identifiers
    f.ENCOUNTER_KEY,
    f.ENCOUNTER_ID,
    f.PATIENT_KEY,

    -- Date information
    f.ENCOUNTER_DATE,
    d.YEAR,
    d.QUARTER,
    d.MONTH,
    d.MONTH_NAME,

    -- Encounter information
    f.ENCOUNTER_TYPE,
    f.LOS_DAYS,

    -- Patient demographics
    f.AGE,
    f.AGE_BAND,
    f.SEX,
    f.INSURANCE_TYPE,

    -- Vital signs
    f.VS_HR_BPM,
    f.VS_SBP_MMHG,
    f.VS_DBP_MMHG,
    f.VS_RR_BREATHS_MIN,
    f.VS_TEMP_F,
    f.VS_SPO2_PCT,
    f.VS_WEIGHT_KG,
    f.VS_HEIGHT_CM,
    f.VS_BMI,

    -- Laboratory measurements
    f.LAB_SODIUM,
    f.LAB_POTASSIUM,
    f.LAB_CREATININE,
    f.LAB_GLUCOSE,
    f.LAB_WBC,
    f.LAB_HEMOGLOBIN,
    f.LAB_PLATELETS,
    f.LAB_HBA1C,
    f.LAB_EGFR,
    f.LAB_CRP,
    f.LAB_ESR,
    f.LAB_FERRITIN

FROM {{ ref('fact_encounter') }} f

INNER JOIN {{ ref('dim_date') }} d
    ON f.ENCOUNTER_DATE_KEY = d.DATE_KEY