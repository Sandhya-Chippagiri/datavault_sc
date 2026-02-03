{%- set yaml_metadata -%}
source_model:
  raw_banking: "RAW_TRANSACTIONS"
derived_columns:
  RECORD_SOURCE: "!PAYMENT_GW"
  LOAD_DATETIME: "LOAD_DATE"
hashed_columns:
  TRANSACTION_HK: "TXN_ID"
  FROM_ACCOUNT_HK: "FROM_ACC_ID"
  TO_ACCOUNT_HK: "TO_ACC_ID"
  TRANSACTION_LINK_HK:
    - "FROM_ACC_ID"
    - "TO_ACC_ID"
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=true,
                  source_model=metadata_dict['source_model'],
                  derived_columns=metadata_dict['derived_columns'],
                  hashed_columns=metadata_dict['hashed_columns']) }}