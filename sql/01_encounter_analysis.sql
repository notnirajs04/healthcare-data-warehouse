-- ============================================================
-- 01_ENCOUNTER_ANALYSIS
-- Purpose:
-- Analyze encounter volume, types, and length of stay.
-- ============================================================


-- ------------------------------------------------------------
-- Query 1: Total encounters by encounter type
-- ------------------------------------------------------------

SELECT
    ENCOUNTER_TYPE,
    COUNT(*) AS ENCOUNTER_COUNT
FROM HEALTHCARE_DB.STAGING.FACT_ENCOUNTER
GROUP BY ENCOUNTER_TYPE
ORDER BY ENCOUNTER_COUNT DESC;


-- ------------------------------------------------------------
-- Query 2: Monthly encounter volume
-- ------------------------------------------------------------

SELECT
    d.YEAR,
    d.MONTH,
    d.MONTH_NAME,
    COUNT(*) AS ENCOUNTER_COUNT
FROM HEALTHCARE_DB.STAGING.FACT_ENCOUNTER f

INNER JOIN HEALTHCARE_DB.STAGING.DIM_DATE d
    ON f.ENCOUNTER_DATE_KEY = d.DATE_KEY

GROUP BY
    d.YEAR,
    d.MONTH,
    d.MONTH_NAME

ORDER BY
    d.YEAR,
    d.MONTH;


-- ------------------------------------------------------------
-- Query 3: Average length of stay by encounter type
-- ------------------------------------------------------------

SELECT
    ENCOUNTER_TYPE,
    COUNT(*) AS ENCOUNTER_COUNT,
    AVG(LOS_DAYS) AS AVG_LOS_DAYS,
    MAX(LOS_DAYS) AS MAX_LOS_DAYS
FROM HEALTHCARE_DB.STAGING.FACT_ENCOUNTER
GROUP BY ENCOUNTER_TYPE
ORDER BY AVG_LOS_DAYS DESC;


-- ------------------------------------------------------------
-- Query 4: Encounters by insurance type
-- ------------------------------------------------------------

SELECT
    INSURANCE_TYPE,
    COUNT(*) AS ENCOUNTER_COUNT
FROM HEALTHCARE_DB.STAGING.FACT_ENCOUNTER
GROUP BY INSURANCE_TYPE
ORDER BY ENCOUNTER_COUNT DESC;


-- ------------------------------------------------------------
-- Query 5: Emergency and inpatient utilization
-- ------------------------------------------------------------

SELECT
    COUNT_IF(ENCOUNTER_TYPE = 'emergency')
        AS EMERGENCY_ENCOUNTERS,

    COUNT_IF(ENCOUNTER_TYPE = 'inpatient')
        AS INPATIENT_ENCOUNTERS,

    COUNT_IF(ENCOUNTER_TYPE = 'outpatient')
        AS OUTPATIENT_ENCOUNTERS,

    COUNT_IF(ENCOUNTER_TYPE = 'telehealth')
        AS TELEHEALTH_ENCOUNTERS
FROM HEALTHCARE_DB.STAGING.FACT_ENCOUNTER;