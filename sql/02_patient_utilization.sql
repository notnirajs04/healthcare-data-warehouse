-- ============================================================
-- 02_PATIENT_UTILIZATION
-- Purpose:
-- Analyze patient-level healthcare utilization.
-- ============================================================


-- ------------------------------------------------------------
-- Query 1: Patients with the highest number of encounters
-- ------------------------------------------------------------

SELECT
    PATIENT_ID,
    AGE,
    AGE_BAND,
    SEX,
    INSURANCE_TYPE,
    TOTAL_ENCOUNTERS
FROM HEALTHCARE_DB.STAGING.MART_PATIENT_UTILIZATION
ORDER BY TOTAL_ENCOUNTERS DESC
LIMIT 20;


-- ------------------------------------------------------------
-- Query 2: Average encounters by insurance type
-- ------------------------------------------------------------

SELECT
    INSURANCE_TYPE,
    COUNT(*) AS PATIENT_COUNT,
    AVG(TOTAL_ENCOUNTERS) AS AVG_ENCOUNTERS_PER_PATIENT,
    AVG(AVG_LOS_DAYS) AS AVG_LOS_DAYS
FROM HEALTHCARE_DB.STAGING.MART_PATIENT_UTILIZATION
GROUP BY INSURANCE_TYPE
ORDER BY AVG_ENCOUNTERS_PER_PATIENT DESC;


-- ------------------------------------------------------------
-- Query 3: Patient utilization by age band
-- ------------------------------------------------------------

SELECT
    AGE_BAND,
    COUNT(*) AS PATIENT_COUNT,
    AVG(TOTAL_ENCOUNTERS) AS AVG_ENCOUNTERS,
    AVG(AVG_LOS_DAYS) AS AVG_LOS_DAYS
FROM HEALTHCARE_DB.STAGING.MART_PATIENT_UTILIZATION
GROUP BY AGE_BAND
ORDER BY AVG_ENCOUNTERS DESC;


-- ------------------------------------------------------------
-- Query 4: Emergency utilization
-- ------------------------------------------------------------

SELECT
    SUM(EMERGENCY_ENCOUNTERS) AS TOTAL_EMERGENCY_ENCOUNTERS,
    AVG(EMERGENCY_ENCOUNTERS) AS AVG_EMERGENCY_ENCOUNTERS_PER_PATIENT,
    COUNT_IF(EMERGENCY_ENCOUNTERS > 0) AS PATIENTS_WITH_EMERGENCY_VISITS
FROM HEALTHCARE_DB.STAGING.MART_PATIENT_UTILIZATION;


-- ------------------------------------------------------------
-- Query 5: Repeat patient analysis
-- ------------------------------------------------------------

SELECT
    COUNT_IF(TOTAL_ENCOUNTERS = 1)
        AS SINGLE_ENCOUNTER_PATIENTS,

    COUNT_IF(TOTAL_ENCOUNTERS > 1)
        AS REPEAT_PATIENTS,

    COUNT_IF(TOTAL_ENCOUNTERS >= 5)
        AS HIGH_UTILIZATION_PATIENTS

FROM HEALTHCARE_DB.STAGING.MART_PATIENT_UTILIZATION;