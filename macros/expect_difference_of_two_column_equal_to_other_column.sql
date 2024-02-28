{% test expect_difference_of_two_column_equal_to_other_column(model, column_name,column_name_1,column_name_2) %}

WITH unit as(
    SELECT
         *, ROUND( ({{column_name_1}} - {{column_name_2}}),2) as difference
    FROM {{ model }}
)
SELECT 
    *
FROM unit
    where difference != {{ column_name }}

{% endtest %}