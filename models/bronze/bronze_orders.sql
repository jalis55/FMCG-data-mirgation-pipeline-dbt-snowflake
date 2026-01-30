{{ config(materialized='incremental') }}

{% if is_incremental() %}
{% set max_date_query %}
    select coalesce(max({{handle_date_format('order_placement_date')}}), '1900-01-01'::date) 
    from {{ this }}
{% endset %}
{% set max_date = run_query(max_date_query).columns[0][0] %}
{% endif %}

select 
    order_id,
    order_placement_date,
    customer_id,
    product_id,
    order_qty,
    current_timestamp() as read_timestamp
from {{ source('staging', 'orders') }}

{% if is_incremental() %}
    where {{ handle_date_format('order_placement_date') }} >= '{{ max_date }}'
{% endif %}