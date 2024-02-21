{% test total_cost_calculation(model, column_name) %}

WITH unit as(
    SELECT
         *, ROUND( (UNITS_SOLD * UNIT_COST),2) as cost
    FROM {{ model }}
)
SELECT 
    *
FROM unit
    where cost != {{ column_name }}

{% endtest %}