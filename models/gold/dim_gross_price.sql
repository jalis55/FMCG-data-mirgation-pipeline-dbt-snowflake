{{ config(materialized='incremental',keys='product_code') }}


with gross_price_with_rank as (
    select 
        product_code,
        month,
        gross_price,
        row_number() over(partition by product_code order by month desc) as rn
    from {{ ref('silver_gross_price') }}
),cleaned_gross_price as (
    select 
        product_code,
        month,
        gross_price
    from gross_price_with_rank
    where rn = 1
)
select 
    product_code,
    extract(year from month) as year,
    gross_price as price_inr
from cleaned_gross_price
