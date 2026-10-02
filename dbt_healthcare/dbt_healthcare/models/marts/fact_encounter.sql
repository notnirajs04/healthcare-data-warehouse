{{
    config(
        materialized='table'
    )
}}

-- ============================================================
-- FACT_ENCOUNTER
-- Grain: One row per healthcare encounter
-- ============================================================

WITH encounters AS (

    SELECT
        *
    FROM {{ ref('stg_ehr_encounters') }}

),

final AS (

    SELECT

        -- ====================================================
        -- Encounter identifiers
        -- ====================================================

        ROW_NUMBER() OVER (
            ORDER BY e.ENCOUNTER_ID
        ) AS ENCOUNTER_KEY,

        e.ENCOUNTER_ID,

        -- ====================================================
        -- Dimension foreign keys
        -- ====================================================

        p.PATIENT_KEY,

        d.DATE_KEY AS ENCOUNTER_DATE_KEY,

        -- ====================================================
        -- Encounter information
        -- ====================================================

        e.ENCOUNTER_DATE,
        e.DISCHARGE_DATE,
        e.ENCOUNTER_TYPE,
        e.LOS_DAYS,

        -- ====================================================
        -- Diagnosis information
        -- ====================================================

        e.DX_PRIMARY,
        e.HCC_FLAG,
        e.N_SECONDARY_DX,

        -- ====================================================
        -- Medication / documentation metrics
        -- ====================================================

        e.N_MEDICATIONS,
        e.POLYPHARMACY_FLAG,
        e.NOTE_TYPE,
        e.NOTE_WORD_COUNT,

        -- ====================================================
        -- Facility information
        -- ====================================================

        e.FACILITY_NPI,
        e.FACILITY_TYPE,
        e.ATTENDING_NPI,
        e.STATE,

        -- ====================================================
        -- Patient demographics at encounter
        -- ====================================================

        e.AGE,
        e.AGE_BAND,
        e.SEX,
        e.RACE_ETHNICITY,
        e.INSURANCE_TYPE,
        e.PCP_FLAG,

        -- ====================================================
        -- Vital signs
        -- ====================================================

        e.VS_HR_BPM,
        e.VS_SBP_MMHG,
        e.VS_DBP_MMHG,
        e.VS_RR_BREATHS_MIN,
        e.VS_TEMP_F,
        e.VS_SPO2_PCT,
        e.VS_WEIGHT_KG,
        e.VS_HEIGHT_CM,
        e.VS_BMI,

        -- ====================================================
        -- Laboratory measurements
        -- ====================================================

        e.LAB_SODIUM,
        e.LAB_POTASSIUM,
        e.LAB_CHLORIDE,
        e.LAB_BICARBONATE_CO2,
        e.LAB_BUN,
        e.LAB_CREATININE,
        e.LAB_GLUCOSE,
        e.LAB_CALCIUM,
        e.LAB_ALT,
        e.LAB_AST,
        e.LAB_ALP,
        e.LAB_TOTAL_BILIRUBIN,
        e.LAB_ALBUMIN,
        e.LAB_WBC,
        e.LAB_RBC,
        e.LAB_HEMOGLOBIN,
        e.LAB_HEMATOCRIT,
        e.LAB_MCV,
        e.LAB_PLATELETS,
        e.LAB_LDL,
        e.LAB_HDL,
        e.LAB_TOTAL_CHOLESTEROL,
        e.LAB_TRIGLYCERIDES,
        e.LAB_HBA1C,
        e.LAB_TSH,
        e.LAB_FREE_T4,
        e.LAB_PT_INR,
        e.LAB_APTT,
        e.LAB_EGFR,
        e.LAB_CRP,
        e.LAB_ESR,
        e.LAB_FERRITIN

    FROM encounters e

    -- Connect each encounter to its patient dimension
    INNER JOIN {{ ref('dim_patient') }} p
        ON e.PATIENT_ID = p.PATIENT_ID

    -- Connect each encounter to the date dimension
    INNER JOIN {{ ref('dim_date') }} d
        ON e.ENCOUNTER_DATE = d.FULL_DATE

)

SELECT *
FROM final