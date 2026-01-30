select 
    product_code,
    order_id,
    order_placement_date,
    customer_id,
    product_id,
    order_qty
from {{ ref('silver_orders') }}
