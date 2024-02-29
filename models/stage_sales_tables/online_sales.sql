{{
    config(
        materialized='incremental',
    )
}}
SELECT 
    $1::number as Sales_ID,
    $2::varchar as Region,
    $3::varchar as Country,
    $4::varchar as Item_type, 
    $5::varchar as Sales_type,
    $6::number as units_sold,
    $7::float as units_price, 
    $8::float as unit_cost,
    $9::float as total_revenue,
    $10::float as total_cost,
    $11::float as total_profit,
    $12::date as sales_date
 FROM @sales_stage WHERE $5 = 'Online'

 {% if is_incremental() %}

  and sales_date > (select max(sales_date) from TARGET_SCHEMA.OFFLINE_SALES_TARGET)

{% endif %}