{% macro stage_fileformat_create(database_name,schema_name) %}

{% set file_format_stm %}
    CREATE FILE FORMAT if not exists  {{database_name}}.{{schema_name}}.my_csv_format
    TYPE = CSV
    SKIP_HEADER = 1;
{% endset %}

{% set results = run_query(file_format_stm) %}

{% set stage_create_stm %}
    CREATE STAGE if not exists {{database_name}}.{{schema_name}}.sales_stage
    URL='azure://azurestoragedbt.blob.core.windows.net/source/sales_record'
    STORAGE_INTEGRATION = sales_azure_integration
    FILE_FORMAT= {{database_name}}.{{schema_name}}.my_csv_format;
{% endset %}

{% set results = run_query(stage_create_stm) %}
{% endmacro %}