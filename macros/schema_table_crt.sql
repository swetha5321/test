{% macro schema_create(database_stage,Target_db) %}

    {% set schema_name %}
    select distinct("table_schema") from INFO_LOG_TABLE.BIG_QUERY_SCHEMA_INFO.META_TABLE_DDL;
{% endset %}
  
    {% set results = run_query(schema_name) %}

    {% if execute %}
{% set results_schema_name = results.columns[0].values() %}

{%- for i in results_schema_name %}
    {% set stage_schema %}
        create schema if not exists {{ database_stage }}.{{ i }}
    {% endset %}
    {% set tabless=run_query(stage_schema) %}
    {% set target_schema %}
        create schema if not exists {{ Target_db }}.{{ i }}
    {% endset %}
    {% set tablss=run_query(target_schema) %}

{% endfor %}
{% endif %}

    {% set table_ddl %}
    select ("ddl") from INFO_LOG_TABLE.BIG_QUERY_SCHEMA_INFO.META_TABLE_DDL;
{% endset %}
    {% set results_table = run_query(table_ddl) %}
    {% set results_table_crt = results_table.columns[0].values() %}

    {%- for i in results_table_crt %}
        {% set stage_db %}
        select replace(replace('{{ i }}','sfdatamigration','{{ database_stage }}'),'\n','')
        {% endset %}
        {% set tabless=run_query(stage_db) %}
        {% set results_ddl_name = tabless.columns[0].values() %}
    {%- for i in results_ddl_name %}
        {% set table_crt %}
           {{i}}
        {% endset %}
        {% do run_query(table_crt) %}
    {% endfor %}
    {% endfor %}

    {%- for i in results_table_crt %}
        {% set stage_db %}
        select replace(replace('{{ i }}','sfdatamigration','{{ Target_db }}'),'\n','')
        {% endset %}
        {% set tabless=run_query(stage_db) %}
        {% set results_ddl_name = tabless.columns[0].values() %}
    {%- for i in results_ddl_name %}
        {% set table_crt %}
           {{i}}
        {% endset %}
        {% do run_query(table_crt) %}
       
    {% endfor %}
    
    {% endfor %}
{% set results = run_query('select 1 as id') %}
    {% do results.print_table() %}

{% endmacro %}
