SELECT *
FROM {{ ref('fct_transactions') }}
WHERE transaction_amount <= 0