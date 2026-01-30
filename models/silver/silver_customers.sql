with duplicate_customers as (
    select
    *,
    row_number() over (partition by customer_id order by current_timestamp desc) as rank
    from {{ ref('bronze_customers') }}
),cleaned_customers as (
    select
    cast(customer_id as string) as customer_id,
    {{ clean_column_value('customer_name') }} as customer_name,
    {{ clean_column_value('city') }} as city,
    read_timestamp
    from duplicate_customers
    where rank = 1
),silver_customers as (

select 
customer_id,
 customer_name,
 case when city is null then {{ handle_null_city('customer_id') }} 
 else {{ map_city('city') }} end as city,
read_timestamp
from cleaned_customers
)

select 
 customer_id,
 customer_name,
 city,
 customer_name ||'-'||city as customer,
 'India' as market,
 'Sports Bar' as platform,
 'Acquisition' as channel,
  read_timestamp
 from silver_customers
