from snowflake.snowpark.functions import udf

def model(dbt, session):
    # Must be either table or incremental (view is not currently supported)
    dbt.config(materialized = "table")
    dbt.config(database='MIGRATION_DB')
    dbt.config(schema='TARGET_SCHEMA')

    # User defined function

    # DataFrame representing an upstream model
    list_value= session.sql("select * from MIGRATION_DB.STAGE_SCHEMA.OFFLINE_SALES").collect()
    dataframe_list=session.create_dataframe(list_value)

    # Add a new column containing the id incremented by one
    return dataframe_list
