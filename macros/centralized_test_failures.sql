{% macro centralize_test_failures(results) %}

  {%- set test_results = [] -%}
  {%- for result in results -%}
    {%- if result.node.resource_type == 'test' and result.status != 'skipped' 
      and (result.node.config.get('store_failures') or flags.STORE_FAILURES ) -%}
      {%- do test_results.append(result) -%}
    {%- endif -%}
  {%- endfor -%}
  
  {%- set central_tbl -%} {{ target.schema }}.test_failure_central {%- endset -%}

 
  
  {{ log("Centralizing test failures in " + central_tbl, info = true) if execute }}

  INSERT INTO {{central_tbl}}
  {% for result in test_results %}
  
    select
      '{{ result.node.name }}' as test_name,
      object_construct_keep_null(*) as test_failures_json,
      current_timestamp() as detected_at
      
    from {{ result.node.relation_name }}
    
    {{ "union all" if not loop.last }}
  
  {% endfor %}
  
  

{% endmacro %}