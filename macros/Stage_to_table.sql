{% macro stg_to_target(stg_database,target_database) %}

{% set schema_table_name %}
   select distinct "table_schema","table_name" from INFO_LOG_TABLE.BIG_QUERY_SCHEMA_INFO.META_TABLE_DDL;
{% endset %}
{% set result_schema_table = run_query(schema_table_name) %}

{% if execute %}

{%- for rows in result_schema_table %}
    {% set schema_name = rows[0] %}
    {% set table_name = rows[1] %}
    {% set query_copy_to_stg %}
       insert into {{target_database}}.{{schema_name}}.{{table_name}}
       select * from {{stg_database}}.{{schema_name}}.{{table_name}};
    {% endset %}
    {% set stage_table = run_query(query_copy_to_stg) %}
{% endfor %}
{% endif %}
{% endmacro %}