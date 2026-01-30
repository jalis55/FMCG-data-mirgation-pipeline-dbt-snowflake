{% macro handle_invalid_id(id_column) %}
    case 
        when {{ id_column }} rlike '^[0-9]+$' 
        then {{ id_column }} 
        else '99999' 
    end
{% endmacro %}