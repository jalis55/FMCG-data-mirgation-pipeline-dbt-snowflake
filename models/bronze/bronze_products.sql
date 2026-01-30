select 
product_id,
product_name,
category,
current_timestamp() as read_timestamp
from {{ source('staging', 'products') }}
