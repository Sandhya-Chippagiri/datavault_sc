{%- set yaml_metadata -%}
source_model:
  raw_banking: "RAW_BANK_ACCOUNTS"
derived_columns:
  RECORD_SOURCE: "!CORE_BANKING"
  LOAD_DATETIME: "LOAD_DATE"
hashed_columns:
  ACCOUNT_HK: "ACC_ID"
  ACCOUNT_HASHDIFF:
    - "ACC_HOLDER_NAME"
    - "ACC_TYPE"
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=true,
                  source_model=metadata_dict['source_model'],
                  derived_columns=metadata_dict['derived_columns'],
                  hashed_columns=metadata_dict['hashed_columns']) }}