{{ config(materialized='incremental', keys='product_code') }}

{% if is_incremental() %}
{% set max_date_query %}
    select coalesce(max(date), '1900-01-01'::date) 
    from {{ this }}
{% endset %}
{% set max_date = run_query(max_date_query).columns[0][0] %}
{% endif %}

with order_details as (
    select 
    product_code,
    date_trunc('MONTH', order_placement_date) as month_start,
    customer_id,
    order_qty
    from {{ ref('silver_orders') }}
    {% if is_incremental() %}
    where order_placement_date >= '{{ max_date }}'
    {% endif %}
), 

order_aggegration as (
    select 
    month_start,
    product_code,
    customer_id,
    sum(order_qty) as sold_qty
    from order_details
    group by month_start, product_code, customer_id
)

select 
    month_start as date,
    product_code,
    customer_id as customer_code,
    sold_qty as sold_quantity
from order_aggegration