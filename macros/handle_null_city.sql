{% macro handle_null_city(customer_id) %}
    case {{ customer_id }}
        when '789521' then 'New Delhi'
        when '2789603' then 'Hyderabad'
        when '3789403' then 'Bengaluru'
        else 'Others'
    end
{% endmacro %}