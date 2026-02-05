WITH latest_sat AS (
    SELECT 
        ACCOUNT_HK,
        ACC_HOLDER_NAME,
        DBT_DATAVAULT.UDF.ToUpperCase(ACC_TYPE) AS ACCOUNT_TYPE,
        OPEN_DATE,
        LOAD_DATETIME,
        SECURITY_NO,
        ROW_NUMBER() OVER (PARTITION BY ACCOUNT_HK ORDER BY LOAD_DATETIME DESC) as row_num
    FROM {{ ref('sat_account_details') }}
)

SELECT
    h.ACCOUNT_HK,           
    h.ACC_ID as account_number,
    s.ACC_HOLDER_NAME as customer_name,
    s.ACCOUNT_TYPE as account_category,
    s.OPEN_DATE as date_opened,
    h.RECORD_SOURCE as system_origin,
    s.SECURITY_NO
FROM {{ ref('hub_account') }} h
LEFT JOIN latest_sat s 
    ON h.ACCOUNT_HK = s.ACCOUNT_HK
    AND s.row_num = 1