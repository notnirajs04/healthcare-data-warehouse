-- ============================================================
-- 04_FACILITY_ANALYSIS
-- Purpose:
-- Analyze encounter distribution across facility types
-- and states.
-- ============================================================


-- ------------------------------------------------------------
-- Query 1: Encounters by facility type
-- ------------------------------------------------------------

SELECT
    FACILITY_TYPE,
    COUNT(*) AS ENCOUNTER_COUNT,
    AVG(LOS_DAYS) AS AVG_LOS_DAYS
FROM HEALTHCARE_DB.STAGING.FACT_ENCOUNTER
GROUP BY FACILITY_TYPE
ORDER BY ENCOUNTER_COUNT DESC;


-- ------------------------------------------------------------
-- Query 2: Encounters by state
-- ------------------------------------------------------------

SELECT
    STATE,
    COUNT(*) AS ENCOUNTER_COUNT
FROM HEALTHCARE_DB.STAGING.FACT_ENCOUNTER
GROUP BY STATE
ORDER BY ENCOUNTER_COUNT DESC;


-- ------------------------------------------------------------
-- Query 3: Facility type by encounter type
-- ------------------------------------------------------------

SELECT
    FACILITY_TYPE,
    ENCOUNTER_TYPE,
    COUNT(*) AS ENCOUNTER_COUNT
FROM HEALTHCARE_DB.STAGING.FACT_ENCOUNTER
GROUP BY
    FACILITY_TYPE,
    ENCOUNTER_TYPE
ORDER BY
    FACILITY_TYPE,
    ENCOUNTER_COUNT DESC;


-- ------------------------------------------------------------
-- Query 4: Facility type and average clinical metrics
-- ------------------------------------------------------------

SELECT
    FACILITY_TYPE,
    COUNT(*) AS ENCOUNTER_COUNT,

    AVG(VS_SPO2_PCT) AS AVG_SPO2,
    AVG(VS_BMI) AS AVG_BMI,
    AVG(LAB_GLUCOSE) AS AVG_GLUCOSE,
    AVG(LAB_CREATININE) AS AVG_CREATININE

FROM HEALTHCARE_DB.STAGING.FACT_ENCOUNTER

GROUP BY FACILITY_TYPE

ORDER BY ENCOUNTER_COUNT DESC;


-- ------------------------------------------------------------
-- Query 5: Facility type by insurance
-- ------------------------------------------------------------

SELECT
    FACILITY_TYPE,
    INSURANCE_TYPE,
    COUNT(*) AS ENCOUNTER_COUNT

FROM HEALTHCARE_DB.STAGING.FACT_ENCOUNTER

GROUP BY
    FACILITY_TYPE,
    INSURANCE_TYPE

ORDER BY
    FACILITY_TYPE,
    ENCOUNTER_COUNT DESC;