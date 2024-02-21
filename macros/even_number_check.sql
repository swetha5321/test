{% test even(model,column_name) %}

    select {{ column_name }} 
    from {{ model }}
    where {{ column_name }} % 2 = 0

{% endtest %}