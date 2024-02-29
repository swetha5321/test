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
    sales_date
 FROM {{ ref('online_sales') }} 

 {% if is_incremental() %}

  where sales_date > (select max(sales_date) from {{ this }})

{% endif %}