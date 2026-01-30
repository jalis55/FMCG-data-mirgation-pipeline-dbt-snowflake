with cleaned_gross_price as (
    select
        product_id,
        sha2(product_id, 256) as product_code,
        {{ handle_date_format('month') }} as month,
        case 
            when gross_price rlike '^[0-9]*\.?[0-9]+$' 
            then try_cast(gross_price as float)  -- or double, decimal
            else 0 
        end as gross_price,
        read_timestamp
    from {{ ref('bronze_gross_price') }}
)
select 
    product_id,
    product_code,
    month,
    abs(gross_price) as gross_price,
    read_timestamp
from cleaned_gross_price