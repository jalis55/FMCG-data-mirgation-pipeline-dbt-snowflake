{{ config(materialized='incremental') }}


select 
    customer_id,
    customer_name,
    city,
    current_timestamp() as read_timestamp
 from {{ source('staging', 'customers') }}