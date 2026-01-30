{% macro map_city(city) %}
    case {{ city }}
        when 'NewDelhi' then 'New Delhi'
        when 'NewDheli' then 'New Delhi'
        when 'NewDelhee' then 'New Delhi'
        when 'Hyderbad' then 'Hyderabad'
        when 'Hyderabadd' then 'Hyderabad'
        when 'Bengaluruu' then 'Bengaluru'
        when 'Bengalore' then 'Bengaluru'
        else {{ city }}
    end
{% endmacro %}