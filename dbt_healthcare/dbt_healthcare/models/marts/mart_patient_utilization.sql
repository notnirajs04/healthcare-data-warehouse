{{
    config(
        materialized='table'
    )
}}

-- ============================================================
-- MART_PATIENT_UTILIZATION
-- Grain: One row per patient
-- Purpose: Patient healthcare utilization analysis
-- ============================================================

SELECT

    p.PATIENT_KEY,
    p.PATIENT_ID,

    -- Patient demographics
    p.AGE,
    p.AGE_BAND,
    p.SEX,
    p.INSURANCE_TYPE,
    p.STATE,

    -- Encounter utilization
    COUNT(f.ENCOUNTER_KEY) AS TOTAL_ENCOUNTERS,

    MIN(f.ENCOUNTER_DATE) AS FIRST_ENCOUNTER_DATE,

    MAX(f.ENCOUNTER_DATE) AS LAST_ENCOUNTER_DATE,

    -- Length of stay
    AVG(f.LOS_DAYS) AS AVG_LOS_DAYS,

    MAX(f.LOS_DAYS) AS MAX_LOS_DAYS,

    -- Encounter type utilization
    COUNT_IF(
        f.ENCOUNTER_TYPE = 'emergency'
    ) AS EMERGENCY_ENCOUNTERS,

    COUNT_IF(
        f.ENCOUNTER_TYPE = 'inpatient'
    ) AS INPATIENT_ENCOUNTERS,

    COUNT_IF(
        f.ENCOUNTER_TYPE = 'outpatient'
    ) AS OUTPATIENT_ENCOUNTERS,

    COUNT_IF(
        f.ENCOUNTER_TYPE = 'telehealth'
    ) AS TELEHEALTH_ENCOUNTERS,

    -- Medication / diagnosis complexity
    AVG(f.N_MEDICATIONS) AS AVG_MEDICATIONS,

    AVG(f.N_SECONDARY_DX) AS AVG_SECONDARY_DIAGNOSES

FROM {{ ref('dim_patient') }} p

INNER JOIN {{ ref('fact_encounter') }} f
    ON p.PATIENT_KEY = f.PATIENT_KEY

GROUP BY

    p.PATIENT_KEY,
    p.PATIENT_ID,
    p.AGE,
    p.AGE_BAND,
    p.SEX,
    p.INSURANCE_TYPE,
    p.STATE