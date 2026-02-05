WITH hub_count AS (
    SELECT COUNT(DISTINCT ACCOUNT_HK) AS total FROM {{ ref('hub_account') }}
),
stage_count AS (
    SELECT COUNT(DISTINCT ACCOUNT_HK) AS total FROM {{ ref('stg_bank_accounts') }}
)

SELECT 
    h.total AS hub_total, 
    s.total AS stage_total
FROM hub_count h, stage_count s
WHERE h.total != s.total