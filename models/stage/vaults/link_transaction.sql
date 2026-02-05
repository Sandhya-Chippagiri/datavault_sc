{{ config(materialized='incremental') }}

{%- set source_model = "stg_transactions" -%}
{%- set src_pk = "TRANSACTION_LINK_HK" -%}
-- We pass these as a explicit list to avoid the 'prefix' macro error
{%- set src_fk = ["FROM_ACCOUNT_HK", "TO_ACCOUNT_HK"] -%}
{%- set src_ldts = "LOAD_DATETIME" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ automate_dv.link(src_pk=src_pk,
                 src_fk=src_fk,
                 src_ldts=src_ldts,
                 src_source=src_source,
                 source_model=source_model) }}