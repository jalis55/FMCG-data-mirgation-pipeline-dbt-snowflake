{{ config(materialized='incremental',keys='product_code') }}

select 
product_code,
product_id,
product,
category,
division,
variant

from {{ ref('silver_products') }}