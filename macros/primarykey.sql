{% test primarykey(model, column_name) %}

{% set expression = column_name ~ " is not null" %}

{{ dbt_expectations.expression_is_true(model,
                                        expression=expression,
                                        group_by_columns=None,
                                        row_condition=row_condition
                                        )
                                        }}

{{ dbt_expectations.test_expect_compound_columns_to_be_unique(model, [column_name], row_condition=row_condition) }}

{% endtest %}