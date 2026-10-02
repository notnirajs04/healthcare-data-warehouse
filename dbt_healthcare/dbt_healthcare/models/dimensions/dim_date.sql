{{
    config(
        materialized='table'
    )
}}

-- ============================================================
-- DIM_DATE
-- Grain: One row per calendar date
-- Range: 2020-01-01 through 2024-12-31
-- ============================================================

WITH date_spine AS (

    SELECT
        DATEADD(
            DAY,
            SEQ4(),
            '2020-01-01'::DATE
        ) AS FULL_DATE

    FROM TABLE(
        GENERATOR(
            ROWCOUNT => 1827
        )
    )

)

SELECT

    -- Surrogate date key in YYYYMMDD format
    TO_NUMBER(
        TO_CHAR(FULL_DATE, 'YYYYMMDD')
    ) AS DATE_KEY,

    FULL_DATE,

    -- Calendar attributes
    YEAR(FULL_DATE) AS YEAR,
    QUARTER(FULL_DATE) AS QUARTER,
    MONTH(FULL_DATE) AS MONTH,
    MONTHNAME(FULL_DATE) AS MONTH_NAME,

    WEEKOFYEAR(FULL_DATE) AS WEEK_OF_YEAR,

    DAY(FULL_DATE) AS DAY_OF_MONTH,

    DAYOFWEEK(FULL_DATE) AS DAY_OF_WEEK,

    DAYNAME(FULL_DATE) AS DAY_NAME,

    -- Useful reporting attributes
    CASE
        WHEN DAYOFWEEK(FULL_DATE) IN (1, 7)
            THEN TRUE
        ELSE FALSE
    END AS IS_WEEKEND,

    CASE
        WHEN MONTH(FULL_DATE) IN (1, 2, 3)
            THEN 'Q1'
        WHEN MONTH(FULL_DATE) IN (4, 5, 6)
            THEN 'Q2'
        WHEN MONTH(FULL_DATE) IN (7, 8, 9)
            THEN 'Q3'
        ELSE 'Q4'
    END AS QUARTER_LABEL

FROM date_spine

WHERE FULL_DATE <= '2024-12-31'::DATE