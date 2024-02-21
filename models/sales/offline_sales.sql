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
    $5::char as Order_priority, 
    $6::date as Order_date,
    $7::number as order_id,
    $8::date as Ship_date ,
    $9::number as units_sold,
    $10::float as units_price, 
    $11::float as unit_cost,
    $12::float as total_revenue,
    $13::float as total_cost,
    $14::float as total_profit,
    datediff(day,$6,$8)::number as Date_difference 
 FROM @sales_stage WHERE $4 = 'Offline'
