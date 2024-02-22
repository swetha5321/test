{% test revenue_calculation(model, column_name) %}

WITH units as(
    SELECT
        *, ROUND( (UNITS_SOLD * UNITS_PRICE),2) as revenue 
    FROM {{ model }}
)
SELECT 
    *
FROM units
    where revenue != {{ column_name }}

{% endtest %}