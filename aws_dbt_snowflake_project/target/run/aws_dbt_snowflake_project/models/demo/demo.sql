
  create or replace   view AIRBNB.dbt_schema.demo
  
  
  
  
  as (
    SELECT * FROM AIRBNB.STAGING.LISTINGS
  );

