{{
    config(
        materialized='incremental',
    )
}}
SELECT 
    $1::varchar as Region,
    $2::varchar as Country,
    $3::varchar as Item_type, 
    $4::varchar as Sales_type ,
    $5::number as units_sold,
    $6::float as units_price, 
    $7::float as unit_cost,
    $8::float as total_revenue,
    $9::float as total_cost,
    $10::float as total_profit,
    $11::date as sales_date
 FROM @sales_stage WHERE $4 = 'Offline'
