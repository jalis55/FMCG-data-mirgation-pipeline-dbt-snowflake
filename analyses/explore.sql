select max({{ handle_date_format('order_placement_date') }}) as max_bronze_date
from {{ ref('bronze_orders') }};