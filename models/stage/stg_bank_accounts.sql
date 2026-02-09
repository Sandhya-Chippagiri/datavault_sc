{%- set yaml_metadata -%}
source_model:
  raw_banking: "RAW_BANK_ACCOUNTS"
derived_columns:
  RECORD_SOURCE: "RECORD_SOURCE"
  LOAD_DATETIME: "LOAD_DATE"
  OPEN_DATE: "LOAD_DATE" 
  EFFECTIVE_TO: "TO_DATE('9999-12-31')"
hashed_columns:
  ACCOUNT_HK: "ACC_ID"
  CUSTOMER_HK: "CUSTOMER_ID"
  # This Key creates the unique relationship between Account and Customer
  LINK_ACCOUNT_CUSTOMER_HK:
    - "ACC_ID"
    - "CUSTOMER_ID"
    - "ACC_TYPE"
  # This Key tracks the status of that specific relationship over time
  EFF_SAT_ACCOUNT_CUSTOMER_HK:
    - "ACC_ID"
    - "CUSTOMER_ID"
    - "LOAD_DATE"
    - "ACC_TYPE"
  ACCOUNT_HASHDIFF:
    is_hashdiff: true
    columns:
      - "ACC_HOLDER_NAME"
      - "OPEN_DATE"
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=true,
                  source_model=metadata_dict['source_model'],
                  derived_columns=metadata_dict['derived_columns'],
                  hashed_columns=metadata_dict['hashed_columns']) }}