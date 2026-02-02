SELECT
    l.TRANSACTION_LINK_HK as transaction_id,
    l.LOAD_DATETIME as transaction_timestamp,
    
    -- Sender Details
    dim_from.account_number as sender_account,
    dim_from.customer_name as sender_name,
    
    -- Receiver Details
    dim_to.account_number as receiver_account,
    dim_to.customer_name as receiver_name,
    
    -- Financial Details
    stg.AMOUNT as transaction_amount

FROM {{ ref('link_transaction') }} l
-- Join for Sender
LEFT JOIN {{ ref('dim_accounts') }} dim_from 
    ON l.FROM_ACCOUNT_HK = dim_from.ACCOUNT_HK 
-- Join for Receiver
LEFT JOIN {{ ref('dim_accounts') }} dim_to 
    ON l.TO_ACCOUNT_HK = dim_to.ACCOUNT_HK
-- Join back to staging for the actual dollars
LEFT JOIN {{ ref('stg_transactions') }} stg 
    ON l.TRANSACTION_LINK_HK = stg.TRANSACTION_LINK_HK