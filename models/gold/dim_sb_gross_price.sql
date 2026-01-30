select 
product_code,
month,
gross_price
from {{ ref('silver_gross_price') }}