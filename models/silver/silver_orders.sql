{{ config(materialized='incremental') }}

with unclead_orders as (
    select 
    order_id,
    {{ handle_date_format("order_placement_date") }} as order_placement_date,
    {{ handle_invalid_id('customer_id') }} as customer_id,
    {{ handle_invalid_id('product_id') }} as product_id,
    order_qty,
    read_timestamp
     from {{ ref('bronze_orders') }}

), duplicate_orders as (
    select 
    order_id,
    order_placement_date,
    customer_id,
    product_id,
    order_qty,
    read_timestamp,
    row_number() over (partition by order_id,order_placement_date,customer_id,product_id,order_qty order by read_timestamp desc) as rank    
     from unclead_orders
    
),cleaned_orders as(
    select
    order_id,
    order_placement_date,
    customer_id,
    cast(product_id as varchar) as product_id,
    order_qty,
    read_timestamp
    from duplicate_orders
    where rank = 1
),silver_orders as(
    select 
    p.product_code,
    o.order_id,
    o.order_placement_date,
    o.customer_id,
    o.product_id,
    o.order_qty,
    o.read_timestamp
    from cleaned_orders as o
    join {{ ref('silver_products') }} as p
    on o.product_id = p.product_id

)

select 
    product_code,
    order_id,
    order_placement_date,
    customer_id,
    product_id,
    order_qty,
    read_timestamp
 from silver_orders
{% if is_incremental() %}
    where order_placement_date >= coalesce(
        (select max(order_placement_date) from {{ this }}), 
        '1900-01-01'::date
    )
{% endif %}