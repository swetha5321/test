{%- test expect_column_sum_equal_to_other_table(model, compare_model,column_name) -%}

WITH test_data as (
SELECT 
    SUM(t1.{{ column_name }}) AS SUM1, 
    SUM(t2.{{ column_name }}) as SUM2 
FROM {{ model }} t1 JOIN {{ compare_model }} t2
)
SELECT * FROM test_data 
where SUM1 != SUM2

{%- endtest -%}