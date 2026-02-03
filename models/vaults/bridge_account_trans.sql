{{ config(materialized='incremental') }}

{%- set yaml_metadata -%}
source_model: "hub_account"
src_pk: "ACCOUNT_HK"
src_ldts: "LOAD_DATETIME"
bridge_walk:
  ACCOUNT_TRANSACTION_WALK:
    bridge_link: "link_transaction"
    bridge_hub: "hub_account"
    link_pk: "TRANSACTION_LINK_HK"
    bridge_pk: "ACCOUNT_HK"
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.bridge(source_model=metadata_dict['source_model'],
                    src_pk=metadata_dict['src_pk'],
                    src_ldts=metadata_dict['src_ldts'],
                    bridge_walk=metadata_dict['bridge_walk']) }}