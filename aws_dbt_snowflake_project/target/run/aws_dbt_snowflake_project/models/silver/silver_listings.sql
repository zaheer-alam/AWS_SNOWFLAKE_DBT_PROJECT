-- back compat for old kwarg name
  
  begin;
    

        insert into AIRBNB.silver.silver_listings ("LISTING_ID", "HOST_ID", "PROPERTY_TYPE", "ROOM_TYPE", "CITY", "COUNTRY", "ACCOMMODATES", "BEDROOMS", "BATHROOMS", "PRICE_TAG", "PRICE_PER_NIGHT", "CREATED_AT")
        (
            select "LISTING_ID", "HOST_ID", "PROPERTY_TYPE", "ROOM_TYPE", "CITY", "COUNTRY", "ACCOMMODATES", "BEDROOMS", "BATHROOMS", "PRICE_TAG", "PRICE_PER_NIGHT", "CREATED_AT"
            from AIRBNB.silver.silver_listings__dbt_tmp
        );
    commit;