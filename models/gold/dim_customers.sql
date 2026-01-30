{{ config(materialized='incremental',keys='customer_code') }}

select 
    customer_id as customer_code,
    customer,
    market,
    platform,
    channel
from {{ ref('silver_customers') }}