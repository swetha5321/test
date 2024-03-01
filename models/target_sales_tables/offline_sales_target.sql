{{
    config(
        schema = 'TARGET_SCHEMA',
        materialized='incremental',
    )
}}
SELECT 
    FILENAME,
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
    CURRENT_TIMESTAMP() as LOADED_AT
 FROM {{ ref('offline_sales') }} 

 {% if is_incremental() %}

  where  Filename not in (SELECT Filename FROM {{ this }})

{% endif %}