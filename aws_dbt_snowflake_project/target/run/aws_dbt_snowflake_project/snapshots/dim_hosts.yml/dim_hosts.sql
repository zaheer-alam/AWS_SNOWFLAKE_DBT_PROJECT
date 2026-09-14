
      
  
    

create or replace transient table AIRBNB.gold.dim_hosts
    
    
    
    
    

    as (
    

    select *,
        md5(coalesce(cast(HOST_ID as varchar ), '')
         || '|' || coalesce(cast(HOST_CREATED_AT as varchar ), '')
        ) as dbt_scd_id,
        HOST_CREATED_AT as dbt_updated_at,
        HOST_CREATED_AT as dbt_valid_from,
        
  
  coalesce(nullif(HOST_CREATED_AT, HOST_CREATED_AT), to_date('9999-12-31'))
  as dbt_valid_to
from (
        with __dbt__cte__hosts as (


WITH hosts AS 
(
    SELECT 
        HOST_ID,
        HOST_NAME,
        IS_SUPERHOST,
        RESPONSE_RATE,
        HOST_CREATED_AT
    FROM 
        AIRBNB.gold.obt
)
SELECT * FROM hosts
) select * from __dbt__cte__hosts
    ) sbq



    )
;


  
  