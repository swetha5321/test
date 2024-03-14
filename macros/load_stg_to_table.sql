{% macro stg_to_table(database_stage) %}

{% set schema_table_name %}
   select distinct "table_schema","table_name","table_columns" from INFO_LOG_TABLE.BIG_QUERY_SCHEMA_INFO.META_TABLE_DDL;
{% endset %}
{% set result_schema_table = run_query(schema_table_name) %}

{% if execute %}

{%- for rows in result_schema_table %}
    {% set schema_name = rows[0] %}
    {% set table_name = rows[1] %}
    {% set table_config = rows[2]%}
    {% set query_copy_to_stg %}
       copy into {{database_stage}}.{{schema_name}}.{{table_name}} from ( select {{table_config}} from @INFO_LOG_TABLE.BIG_QUERY_SCHEMA_INFO.GCP_STAGE_V1/{{schema_name}}/{{table_name}}(file_format => INFO_LOG_TABLE.BIG_QUERY_SCHEMA_INFO.PARQUET_FORMAT_GCP))
    {% endset %}
    {% set stage_table = run_query(query_copy_to_stg) %}
{% endfor %}
{% endif %}
{% endmacro %}
