{{ config(
    materialized = "incremental",
    keys = 'LISTING_ID'
)}}

SELECT 
    LISTING_ID,
    HOST_ID,
    {{ trimmer('PROPERTY_TYPE') }} AS PROPERTY_TYPE,
    ROOM_TYPE,
    CITY,
    COUNTRY,
    ACCOMMODATES,
    BEDROOMS,
    BATHROOMS,
    {{ tag('PRICE_PER_NIGHT') }} AS PRICE_TAG,
    PRICE_PER_NIGHT,
    CREATED_AT
FROM 
    {{ref('bronze_listings')}}
    