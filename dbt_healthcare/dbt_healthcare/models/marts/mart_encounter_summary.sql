{{
    config(
        materialized='table'
    )
}}

-- ============================================================
-- MART_ENCOUNTER_SUMMARY
-- Grain: One row per month + encounter type
-- Purpose: Reporting and dashboard analytics
-- ============================================================

SELECT

    -- Calendar attributes
    d.YEAR,
    d.QUARTER,
    d.MONTH,
    d.MONTH_NAME,

    -- Encounter category
    f.ENCOUNTER_TYPE,

    -- Core encounter metrics
    COUNT(*) AS ENCOUNTER_COUNT,

    AVG(f.LOS_DAYS) AS AVG_LOS_DAYS,

    AVG(f.AGE) AS AVG_PATIENT_AGE,

    -- Clinical metrics
    AVG(f.VS_SPO2_PCT) AS AVG_SPO2_PCT,

    AVG(f.LAB_GLUCOSE) AS AVG_GLUCOSE,

    AVG(f.LAB_CREATININE) AS AVG_CREATININE,

    -- Utilization / complexity metrics
    AVG(f.N_MEDICATIONS) AS AVG_MEDICATIONS,

    AVG(f.N_SECONDARY_DX) AS AVG_SECONDARY_DIAGNOSES

FROM {{ ref('fact_encounter') }} f

INNER JOIN {{ ref('dim_date') }} d
    ON f.ENCOUNTER_DATE_KEY = d.DATE_KEY

GROUP BY
    d.YEAR,
    d.QUARTER,
    d.MONTH,
    d.MONTH_NAME,
    f.ENCOUNTER_TYPE