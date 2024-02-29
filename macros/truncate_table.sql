{% macro table_truncate(table_schema,database_name) %}

{% set sql_ts %}
    select distinct concat(TABLE_CATALOG,'.',TABLE_SCHEMA,'.',TABLE_NAME) from SNOWFLAKE.ACCOUNT_USAGE.TABLES where TABLE_SCHEMA ={{table_schema}} and TABLE_CATALOG={{database_name}};
{% endset %}

{% set results = run_query(sql_ts) %}

{% if execute %}
{% set results_list = results.columns[0].values() %}

{% endif %}

{%- for i in results_list %}
    {% set sql %}
        truncate table {{i}} 
    {% endset %}
  {% set tabless=run_query(sql) %}
{% endfor %}
{% endmacro %}