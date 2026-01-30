select 
    product_id,
    month,
    gross_price,
    current_timestamp() as read_timestamp
from {{ source('staging', 'gross_price') }}