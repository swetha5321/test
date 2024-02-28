{% test expect_column_value_to_be_positive(model,column_name) %}

    select *
    from {{ model }}
    where {{ column_name }} < 0

{% endtest %}


