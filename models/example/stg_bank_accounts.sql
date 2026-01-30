{%- set yaml_metadata -%}
source_model: "RAW_BANK_ACCOUNTS" # This matches the name in sources.yml
derived_columns:
  RECORD_SOURCE: "!CORE_BANKING"  # Adding a static label
  LOAD_DATETIME: "LOAD_DATE"      # Renaming for consistency
hashed_columns:
  ACCOUNT_HK: "ACC_ID"            # This creates the unique Hash Key for the Account
  ACCOUNT_HASHDIFF:               # This creates a "fingerprint" of the data to detect changes
    - "ACC_HOLDER_NAME"
    - "ACC_TYPE"
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.stage(include_source_columns=true,
                  source_model=metadata_dict['source_model'],
                  derived_columns=metadata_dict['derived_columns'],
                  hashed_columns=metadata_dict['hashed_columns']) }}