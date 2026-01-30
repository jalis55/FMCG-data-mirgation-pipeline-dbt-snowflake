with duplicate_products as (
    select
    *,
    row_number() over (partition by product_id order by current_timestamp desc) as rank
    from {{ ref('bronze_products') }}
),uncleaned_products as(
select 
    product_id,
    {{ handle_misspell('product_name','protien','protein') }} as product_name,
    {{ handle_misspell('category','protien','protein') }} as category,

     REGEXP_SUBSTR(product_name, '\\((.*?)\\)', 1, 1, 'e', 1) AS variant,
    read_timestamp
from duplicate_products
    where rank = 1
),cleaned_products as (
    select 
    {{clean_column_value('product_id')}} as product_id,
    {{clean_column_value('product_name')}} as product_name,
    sha2(product_name, 256) as product_code,
    {{clean_column_value('category')}} as category,
    {{clean_column_value('variant')}} as variant,
    read_timestamp
     from uncleaned_products
    
)



select 
product_code,
{{ handle_invalid_id('product_id') }} as product_id,
product_name as product,
category,           
case  
    when category='Engery Bars' then 'Nuritrition Bars'
    when category='Protein Bars' then 'Nuritrition Bars'
    when category='Granola & Cereals' then 'Breakfast Foods'
    when category='Recovery Dairy' then 'Dairy & Recovery'
    when category='Healthy Snacks' then 'Healthy Snacks'
    when category='Electrolyte MixEnergy Drinks' then 'Hydration & Electrolytes'
    else 'Others'
end as division,
variant,
read_timestamp
from cleaned_products