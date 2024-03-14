{% macro stage_fileformat_create(database_name,schema_name) %}

{% set stage_landed_table_schema %}
   create or replace schema INTERMEDIATE.STAGE_LANDED;
{% endset %}
{% set results = run_query(stage_landed_table_schema ) %}

{% set file_format_stm %}
    CREATE FILE FORMAT if not exists  {{database_name}}.{{schema_name}}.my_csv_format
    TYPE = CSV
    SKIP_HEADER = 1;
{% endset %}

{% set results = run_query(file_format_stm) %}

{% set stage_create_stm %}
    CREATE STAGE if not exists {{database_name}}.{{schema_name}}.sales_stage
    URL='azure://azurestoragedbt.blob.core.windows.net/source/sales_record_sp'
    STORAGE_INTEGRATION = sales_azure_integration
    FILE_FORMAT= {{database_name}}.{{schema_name}}.my_csv_format;
{% endset %}

{% set results = run_query(stage_create_stm) %}

{% set INFORMATION_LOAD_FILE_STAGE_DB %}
create or replace table  INFO_MAINTAIN_DB.PUBLIC.INFORMATION_LOAD_FILE_STAGE_DB (file_name varchar,row_count_INFile number,count_valid_row number,invalid_row_count number,table_name varchar);

{% endset %}

{% set results = run_query(INFORMATION_LOAD_FILE_STAGE_DB) %}

{% set invalid_Data_schema %}
create or replace schema INTERMEDIATE.INVALID_DATA;
{% endset %}

{% set results = run_query(invalid_Data_schema) %}



{% endmacro %}