-- back compat for old kwarg name
  
  begin;
    

        insert into AIRBNB.silver.silver_hosts ("HOST_ID", "HOST_NAME", "IS_SUPERHOST", "RESPONSE_RATE", "CREATED_AT")
        (
            select "HOST_ID", "HOST_NAME", "IS_SUPERHOST", "RESPONSE_RATE", "CREATED_AT"
            from AIRBNB.silver.silver_hosts__dbt_tmp
        );
    commit;