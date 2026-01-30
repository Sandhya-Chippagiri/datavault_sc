{%- set yaml_metadata -%}
source_model: "RAW_TRANSACTIONS"
derived_columns:
  RECORD_SOURCE: "!PAYMENT_GW"
  LOAD_DATETIME: "LOAD_DATE"
hashed_columns:
  -- 1. The Hash Key for the Transaction itself
  TRANSACTION_HK: "TXN_ID"
  
  -- 2. The Hash Key for the Sender (Links to Hub_Account)
  FROM_ACCOUNT_HK: "FROM_ACC_ID"
  
  -- 3. The Hash Key for the Receiver (Links to Hub_Account)
  TO_ACCOUNT_HK: "TO_ACC_ID"

  -- 4. The Link Hash Key (This represents the unique relationship between the two accounts)
  TRANSACTION_LINK_HK:
    - "FROM_ACC_ID"
    - "TO_ACC_ID"
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=true,
                  source_model=metadata_dict['source_model'],
                  derived_columns=metadata_dict['derived_columns'],
                  hashed_columns=metadata_dict['hashed_columns']) }}