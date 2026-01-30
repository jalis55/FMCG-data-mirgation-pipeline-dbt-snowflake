{% macro handle_misspell(column_name,misspell,correct_spelling) %}
    regexp_replace({{ column_name }}, '{{ misspell }}', '{{ correct_spelling }}', 1, 0, 'i')
{% endmacro %}