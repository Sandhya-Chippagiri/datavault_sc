{{
    config(
        materialized='incremental',
        unique_key='ACCOUNT_HK'
    )
}}

-- 1. Get the latest account descriptive attributes
WITH latest_acc_sat AS (
    SELECT 
        ACCOUNT_HK,
        ACC_HOLDER_NAME,
        DBT_DATAVAULT.UDF.ToUpperCase(ACC_TYPE) AS ACCOUNT_TYPE,
        OPEN_DATE,
        CUSTOMER_ID,
        LOAD_DATETIME,
        ROW_NUMBER() OVER (PARTITION BY ACCOUNT_HK ORDER BY LOAD_DATETIME DESC) as row_num
    FROM {{ ref('sat_account_details') }}
),

latest_cust_stg AS (
    SELECT 
        CUSTOMER_ID,
        FIRST_NAME || ' ' || LAST_NAME AS customer_full_name,
        EMAIL_ID,
        PHONE_NO,
        SSN,
        LOAD_DATETIME
    FROM {{ ref('stg_bank_customers') }}
    QUALIFY ROW_NUMBER() OVER (PARTITION BY CUSTOMER_ID ORDER BY LOAD_DATETIME DESC) = 1
),


cust_hub AS (
    SELECT 
        CUSTOMER_HK,
        CUSTOMER_ID
    FROM {{ ref('hub_customers') }}
)


SELECT
    h_acc.ACCOUNT_HK,           
    h_acc.ACC_ID as account_number,
    h_cust.CUSTOMER_HK,
    c.CUSTOMER_ID as customer_id,
    c.customer_full_name AS customer_name,
    s.ACCOUNT_TYPE as account_category,
    s.OPEN_DATE as date_opened,
    s.LOAD_DATETIME as LOAD_DT,
    c.PHONE_NO,
    h_acc.RECORD_SOURCE as system_origin,
    c.EMAIL_ID,
    c.SSN
FROM {{ ref('hub_account') }} h_acc
LEFT JOIN latest_acc_sat s 
    ON h_acc.ACCOUNT_HK = s.ACCOUNT_HK
    AND s.row_num = 1

LEFT JOIN latest_cust_stg c
    ON s.CUSTOMER_ID = c.CUSTOMER_ID

LEFT JOIN cust_hub h_cust
    ON c.CUSTOMER_ID = h_cust.CUSTOMER_ID

{% if is_incremental() %}
  
  WHERE s.LOAD_DATETIME > (SELECT MAX(LOAD_DT) FROM {{ this }})
{% endif %}