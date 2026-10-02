{{
    config(
        materialized='table'
    )
}}

-- ============================================================
-- DIM_PATIENT
-- Grain: One row per patient
-- ============================================================

WITH patient_data AS (

    -- Get patient-level attributes from the staging model.
    -- We use ref() so dbt understands the dependency:
    -- STG_EHR_ENCOUNTERS → DIM_PATIENT

    SELECT
        PATIENT_ID,
        AGE,
        AGE_BAND,
        SEX,
        RACE_ETHNICITY,
        INSURANCE_TYPE,
        PCP_FLAG,
        STATE

    FROM {{ ref('stg_ehr_encounters') }}

),

deduplicated AS (

    -- A patient can appear in many encounter records.
    -- Assign a row number to each patient's records so
    -- that we can retain exactly one row per patient.

    SELECT
        PATIENT_ID,
        AGE,
        AGE_BAND,
        SEX,
        RACE_ETHNICITY,
        INSURANCE_TYPE,
        PCP_FLAG,
        STATE,

        ROW_NUMBER() OVER (
            PARTITION BY PATIENT_ID
            ORDER BY AGE DESC
        ) AS ROW_NUM

    FROM patient_data

)

SELECT

    -- Warehouse-generated surrogate key
    ROW_NUMBER() OVER (
        ORDER BY PATIENT_ID
    ) AS PATIENT_KEY,

    PATIENT_ID,
    AGE,
    AGE_BAND,
    SEX,
    RACE_ETHNICITY,
    INSURANCE_TYPE,
    PCP_FLAG,
    STATE

FROM deduplicated

WHERE ROW_NUM = 1