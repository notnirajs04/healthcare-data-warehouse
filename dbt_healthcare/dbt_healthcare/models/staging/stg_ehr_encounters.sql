{{
    config(
        materialized='view'
    )
}}

WITH source_data AS (

    SELECT
        *
    FROM HEALTHCARE_DB.RAW.EHR_ENCOUNTERS

),

staged AS (

    SELECT

        -- ============================================
        -- IDENTIFIERS
        -- ============================================

        ENCOUNTER_ID,
        PATIENT_ID,

        -- ============================================
        -- ENCOUNTER INFORMATION
        -- ============================================

        TRY_TO_DATE(ENCOUNTER_DATE) AS ENCOUNTER_DATE,
        ENCOUNTER_TYPE,
        TRY_TO_DATE(DISCHARGE_DATE) AS DISCHARGE_DATE,
        TRY_TO_NUMBER(LOS_DAYS) AS LOS_DAYS,

        -- ============================================
        -- DIAGNOSIS INFORMATION
        -- ============================================

        DX_PRIMARY,
        TRY_TO_BOOLEAN(HCC_FLAG) AS HCC_FLAG,
        TRY_TO_NUMBER(N_SECONDARY_DX) AS N_SECONDARY_DX,

        -- ============================================
        -- MEDICATION / NOTE INFORMATION
        -- ============================================

        TRY_TO_NUMBER(N_MEDICATIONS) AS N_MEDICATIONS,
        TRY_TO_BOOLEAN(POLYPHARMACY_FLAG) AS POLYPHARMACY_FLAG,
        NOTE_TYPE,
        TRY_TO_NUMBER(NOTE_WORD_COUNT) AS NOTE_WORD_COUNT,

        -- ============================================
        -- FACILITY INFORMATION
        -- ============================================

        FACILITY_TYPE,
        FACILITY_NPI,
        ATTENDING_NPI,

        -- ============================================
        -- VITAL SIGNS
        -- ============================================

        TRY_TO_NUMBER(VS_HR_BPM, 10, 2) AS VS_HR_BPM,
        TRY_TO_NUMBER(VS_SBP_MMHG, 10, 2) AS VS_SBP_MMHG,
        TRY_TO_NUMBER(VS_DBP_MMHG, 10, 2) AS VS_DBP_MMHG,
        TRY_TO_NUMBER(VS_RR_BREATHS_MIN, 10, 2) AS VS_RR_BREATHS_MIN,
        TRY_TO_NUMBER(VS_TEMP_F, 10, 2) AS VS_TEMP_F,
        TRY_TO_NUMBER(VS_SPO2_PCT, 10, 2) AS VS_SPO2_PCT,
        TRY_TO_NUMBER(VS_WEIGHT_KG, 10, 2) AS VS_WEIGHT_KG,
        TRY_TO_NUMBER(VS_HEIGHT_CM, 10, 2) AS VS_HEIGHT_CM,
        TRY_TO_NUMBER(VS_BMI, 10, 2) AS VS_BMI,

        -- ============================================
        -- LABORATORY RESULTS
        -- ============================================

        TRY_TO_NUMBER(LAB_SODIUM, 10, 2) AS LAB_SODIUM,
        LAB_SODIUM_FLAG,

        TRY_TO_NUMBER(LAB_POTASSIUM, 10, 2) AS LAB_POTASSIUM,
        LAB_POTASSIUM_FLAG,

        TRY_TO_NUMBER(LAB_CHLORIDE, 10, 2) AS LAB_CHLORIDE,
        LAB_CHLORIDE_FLAG,

        TRY_TO_NUMBER(LAB_BICARBONATE_CO2, 10, 2) AS LAB_BICARBONATE_CO2,
        LAB_BICARBONATE_CO2_FLAG,

        TRY_TO_NUMBER(LAB_BUN, 10, 2) AS LAB_BUN,
        LAB_BUN_FLAG,

        TRY_TO_NUMBER(LAB_CREATININE, 10, 2) AS LAB_CREATININE,
        LAB_CREATININE_FLAG,

        TRY_TO_NUMBER(LAB_GLUCOSE, 10, 2) AS LAB_GLUCOSE,
        LAB_GLUCOSE_FLAG,

        TRY_TO_NUMBER(LAB_CALCIUM, 10, 2) AS LAB_CALCIUM,
        LAB_CALCIUM_FLAG,

        TRY_TO_NUMBER(LAB_ALT, 10, 2) AS LAB_ALT,
        LAB_ALT_FLAG,

        TRY_TO_NUMBER(LAB_AST, 10, 2) AS LAB_AST,
        LAB_AST_FLAG,

        TRY_TO_NUMBER(LAB_ALP, 10, 2) AS LAB_ALP,
        LAB_ALP_FLAG,

        TRY_TO_NUMBER(LAB_TOTAL_BILIRUBIN, 10, 2) AS LAB_TOTAL_BILIRUBIN,
        LAB_TOTAL_BILIRUBIN_FLAG,

        TRY_TO_NUMBER(LAB_ALBUMIN, 10, 2) AS LAB_ALBUMIN,
        LAB_ALBUMIN_FLAG,

        TRY_TO_NUMBER(LAB_WBC, 10, 2) AS LAB_WBC,
        LAB_WBC_FLAG,

        TRY_TO_NUMBER(LAB_RBC, 10, 2) AS LAB_RBC,
        LAB_RBC_FLAG,

        TRY_TO_NUMBER(LAB_HEMOGLOBIN, 10, 2) AS LAB_HEMOGLOBIN,
        LAB_HEMOGLOBIN_FLAG,

        TRY_TO_NUMBER(LAB_HEMATOCRIT, 10, 2) AS LAB_HEMATOCRIT,
        LAB_HEMATOCRIT_FLAG,

        TRY_TO_NUMBER(LAB_MCV, 10, 2) AS LAB_MCV,
        LAB_MCV_FLAG,

        TRY_TO_NUMBER(LAB_PLATELETS, 10, 2) AS LAB_PLATELETS,
        LAB_PLATELETS_FLAG,

        TRY_TO_NUMBER(LAB_LDL, 10, 2) AS LAB_LDL,
        LAB_LDL_FLAG,

        TRY_TO_NUMBER(LAB_HDL, 10, 2) AS LAB_HDL,
        LAB_HDL_FLAG,

        TRY_TO_NUMBER(LAB_TOTAL_CHOLESTEROL, 10, 2) AS LAB_TOTAL_CHOLESTEROL,
        LAB_TOTAL_CHOLESTEROL_FLAG,

        TRY_TO_NUMBER(LAB_TRIGLYCERIDES, 10, 2) AS LAB_TRIGLYCERIDES,
        LAB_TRIGLYCERIDES_FLAG,

        TRY_TO_NUMBER(LAB_HBA1C, 10, 2) AS LAB_HBA1C,
        LAB_HBA1C_FLAG,

        TRY_TO_NUMBER(LAB_TSH, 10, 2) AS LAB_TSH,
        LAB_TSH_FLAG,

        TRY_TO_NUMBER(LAB_FREE_T4, 10, 2) AS LAB_FREE_T4,
        LAB_FREE_T4_FLAG,

        TRY_TO_NUMBER(LAB_PT_INR, 10, 2) AS LAB_PT_INR,
        LAB_PT_INR_FLAG,

        TRY_TO_NUMBER(LAB_APTT, 10, 2) AS LAB_APTT,
        LAB_APTT_FLAG,

        TRY_TO_NUMBER(LAB_EGFR, 10, 2) AS LAB_EGFR,
        LAB_EGFR_FLAG,

        TRY_TO_NUMBER(LAB_CRP, 10, 2) AS LAB_CRP,
        LAB_CRP_FLAG,

        TRY_TO_NUMBER(LAB_ESR, 10, 2) AS LAB_ESR,
        LAB_ESR_FLAG,

        TRY_TO_NUMBER(LAB_FERRITIN, 10, 2) AS LAB_FERRITIN,
        LAB_FERRITIN_FLAG,

        -- ============================================
        -- PATIENT DEMOGRAPHICS
        -- ============================================

        TRY_TO_NUMBER(AGE) AS AGE,
        AGE_BAND,
        SEX,
        RACE_ETHNICITY,
        INSURANCE_TYPE,
        TRY_TO_BOOLEAN(PCP_FLAG) AS PCP_FLAG,
        STATE,

        -- ============================================
        -- SECONDARY DIAGNOSES
        -- ============================================

        DX_SECONDARY_1,
        DX_SECONDARY_2,
        DX_SECONDARY_3,
        DX_SECONDARY_4,
        DX_SECONDARY_5

    FROM source_data

)

SELECT *
FROM staged