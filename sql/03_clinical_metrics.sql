-- ============================================================
-- 03_CLINICAL_METRICS
-- Purpose:
-- Analyze clinical measurements across healthcare encounters.
-- ============================================================


-- ------------------------------------------------------------
-- Query 1: Average vital signs by encounter type
-- ------------------------------------------------------------

SELECT
    ENCOUNTER_TYPE,

    AVG(VS_HR_BPM) AS AVG_HEART_RATE,
    AVG(VS_SBP_MMHG) AS AVG_SYSTOLIC_BP,
    AVG(VS_DBP_MMHG) AS AVG_DIASTOLIC_BP,
    AVG(VS_RR_BREATHS_MIN) AS AVG_RESPIRATORY_RATE,
    AVG(VS_TEMP_F) AS AVG_TEMPERATURE_F,
    AVG(VS_SPO2_PCT) AS AVG_SPO2

FROM HEALTHCARE_DB.STAGING.MART_CLINICAL_METRICS

GROUP BY ENCOUNTER_TYPE

ORDER BY ENCOUNTER_TYPE;


-- ------------------------------------------------------------
-- Query 2: Laboratory averages by encounter type
-- ------------------------------------------------------------

SELECT
    ENCOUNTER_TYPE,

    AVG(LAB_GLUCOSE) AS AVG_GLUCOSE,
    AVG(LAB_CREATININE) AS AVG_CREATININE,
    AVG(LAB_HBA1C) AS AVG_HBA1C,
    AVG(LAB_WBC) AS AVG_WBC,
    AVG(LAB_HEMOGLOBIN) AS AVG_HEMOGLOBIN,
    AVG(LAB_PLATELETS) AS AVG_PLATELETS

FROM HEALTHCARE_DB.STAGING.MART_CLINICAL_METRICS

GROUP BY ENCOUNTER_TYPE

ORDER BY ENCOUNTER_TYPE;


-- ------------------------------------------------------------
-- Query 3: BMI distribution by age band
-- ------------------------------------------------------------

SELECT
    AGE_BAND,
    COUNT(*) AS ENCOUNTER_COUNT,
    AVG(VS_BMI) AS AVG_BMI,
    MIN(VS_BMI) AS MIN_BMI,
    MAX(VS_BMI) AS MAX_BMI

FROM HEALTHCARE_DB.STAGING.MART_CLINICAL_METRICS

GROUP BY AGE_BAND

ORDER BY AGE_BAND;


-- ------------------------------------------------------------
-- Query 4: Monthly average SpO2
-- ------------------------------------------------------------

SELECT
    YEAR,
    MONTH,
    MONTH_NAME,

    COUNT(*) AS ENCOUNTER_COUNT,

    AVG(VS_SPO2_PCT) AS AVG_SPO2

FROM HEALTHCARE_DB.STAGING.MART_CLINICAL_METRICS

GROUP BY
    YEAR,
    MONTH,
    MONTH_NAME

ORDER BY
    YEAR,
    MONTH;


-- ------------------------------------------------------------
-- Query 5: Clinical metrics by insurance type
-- ------------------------------------------------------------

SELECT
    INSURANCE_TYPE,

    COUNT(*) AS ENCOUNTER_COUNT,

    AVG(VS_SPO2_PCT) AS AVG_SPO2,
    AVG(LAB_GLUCOSE) AS AVG_GLUCOSE,
    AVG(LAB_CREATININE) AS AVG_CREATININE,
    AVG(VS_BMI) AS AVG_BMI

FROM HEALTHCARE_DB.STAGING.MART_CLINICAL_METRICS

GROUP BY INSURANCE_TYPE

ORDER BY ENCOUNTER_COUNT DESC;