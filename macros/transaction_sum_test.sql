
{% test transaction_sum_test(model, column_name, test_value, test_year) %}
WITH temp AS (
    SELECT
        SUM({{ column_name }}) AS trx_sum
    FROM
        {{ model }}
    WHERE
        EXTRACT(YEAR from SHIP_DATE) = {{ test_year }}
)
SELECT
    *
FROM
    temp
WHERE
    trx_sum < {{ test_value }}
{% endtest %}