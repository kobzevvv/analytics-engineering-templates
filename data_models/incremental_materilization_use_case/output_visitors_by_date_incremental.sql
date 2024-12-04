{{ 
   config(
       materialized='incremental'
   ) 
}}

select *
from {{ref('input_visitors_by_date')}}
WHERE updated_at > (SELECT MAX(visit_date) FROM {{ this }})

-- incremental materilization code: https://github.com/dbt-labs/dbt-bigquery/blob/main/dbt/include/bigquery/macros/materializations/incremental.sql

-- ./run_inside_docker.sh dbt run -m +output_visitors_by_date_incremental -t test