{% macro warehouse_suspend() %}

{% set sql_ts %}
    select name from ( select distinct warehouse_name as name, warehouse_id  from SNOWFLAKE.ACCOUNT_USAGE.WAREHOUSE_EVENTS_HISTORY );
{% endset %}

{% set results = run_query(sql_ts) %}

{% if execute %}
{% set results_list = results.columns[0].values() %}

{% endif %}

{%- for i in results_list %}
    {% set sql %}
        alter warehouse {{i}} resume 
    {% endset %}
  {% set tabless=run_query(sql) %}
{% endfor %}
{% endmacro %}