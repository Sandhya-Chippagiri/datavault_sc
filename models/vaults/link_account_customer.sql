{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
source_model: "stg_bank_accounts"
src_pk: "LINK_ACCOUNT_CUSTOMER_HK"
src_fk:
  - "ACCOUNT_HK"
  - "CUSTOMER_HK"
src_ldts: "LOAD_DATETIME"
src_source: "RECORD_SOURCE"
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.link(src_pk=metadata_dict["src_pk"],
                    src_fk=metadata_dict["src_fk"],
                    src_ldts=metadata_dict["src_ldts"],
                    src_source=metadata_dict["src_source"],
                    source_model=metadata_dict["source_model"]) }}