-- back compat for old kwarg name
  
  begin;
    

        insert into AIRBNB.silver.silver_bookings ("BOOKING_ID", "LISTING_ID", "BOOKING_DATE", "TOTAL_AMOUNT", "BOOKING_STATUS", "CREATED_AT")
        (
            select "BOOKING_ID", "LISTING_ID", "BOOKING_DATE", "TOTAL_AMOUNT", "BOOKING_STATUS", "CREATED_AT"
            from AIRBNB.silver.silver_bookings__dbt_tmp
        );
    commit;