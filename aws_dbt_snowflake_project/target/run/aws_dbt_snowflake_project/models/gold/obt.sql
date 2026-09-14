
  
    

create or replace transient table AIRBNB.gold.obt
    
    
    
    
    

    as (



SELECT
    
        b.*,
    
        l.HOST_ID, l.PROPERTY_TYPE, l.ROOM_TYPE, l.CITY, l.COUNTRY, l.ACCOMMODATES, l.BEDROOMS, l.BATHROOMS, l.PRICE_PER_NIGHT, l.PRICE_TAG, l.CREATED_AT AS LISTING_CREATED_AT,
    
        h.HOST_NAME, h.IS_SUPERHOST, h.RESPONSE_RATE, h.CREATED_AT AS HOST_CREATED_AT
    

FROM
    

        

            AIRBNB.silver.silver_bookings AS b

        

    

        

            LEFT JOIN AIRBNB.silver.silver_listings AS l
                ON b.LISTING_ID = l.LISTING_ID

        

    

        

            LEFT JOIN AIRBNB.silver.silver_hosts AS h
                ON l.HOST_ID = h.HOST_ID

        

    
    )
;


  