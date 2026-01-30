{% macro clean_column_value(column_name) %}
    trim(initcap({{ column_name }}))
{% endmacro %}