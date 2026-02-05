{%- set yaml_metadata -%}
source_model:
  raw_banking: "RAW_BANK_CUSTOMER"
derived_columns:
  RECORD_SOURCE: "!CRM"
  LOAD_DATETIME: "LOAD_DATE"
hashed_columns:
  CUSTOMER_HK: "CUSTOMER_ID"
  CUSTOMER_HASHDIFF:
    - "FIRST_NAME"
    - "EMAIL_ID"
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=true,
                  source_model=metadata_dict['source_model'],
                  derived_columns=metadata_dict['derived_columns'],
                  hashed_columns=metadata_dict['hashed_columns']) }}