{%- set columns = adapter.get_columns_in_relation(OFFLINE_SALES) -%}

{% for column in columns %}
  {{ log("Column: " ~ column, info=true) }}
{% endfor %}