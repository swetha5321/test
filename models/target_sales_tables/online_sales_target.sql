{{
    config(
        schema = 'TARGET_SCHEMA',
        materialized='incremental',
    )
}}
SELECT 
    Sales_ID,
    Region,
    Country,
    Item_type, 
    Sales_type,
    units_sold,
    units_price, 
    unit_cost,
    total_revenue,
    total_cost,
    total_profit,
    sales_date,
    CURRENT_TIMESTAMP() as LOADED_AT,
    FILENAME
 FROM {{ ref('online_sales') }} 

 {% if is_incremental() %}

  WHERE Filename not in (SELECT Filename FROM {{this}})

{% endif %}