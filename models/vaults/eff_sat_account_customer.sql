{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
source_model: "stg_bank_accounts"
src_pk: "EFF_SAT_ACCOUNT_CUSTOMER_HK"
src_dfk: "ACCOUNT_HK"           
src_sfk: "CUSTOMER_HK"          
src_start_date: "OPEN_DATE"    
src_end_date: "EFFECTIVE_TO"    
src_eff: "EFFECTIVE_FROM"           
src_ldts: "LOAD_DATETIME"
src_source: "RECORD_SOURCE"
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.eff_sat(src_pk=metadata_dict["src_pk"],
                       src_dfk=metadata_dict["src_dfk"],
                       src_sfk=metadata_dict["src_sfk"],
                       src_start_date=metadata_dict["src_start_date"],
                       src_end_date=metadata_dict["src_end_date"],
                       src_eff=metadata_dict["src_eff"],
                       src_ldts=metadata_dict["src_ldts"],
                       src_source=metadata_dict["src_source"],
                       source_model=metadata_dict["source_model"]) }}