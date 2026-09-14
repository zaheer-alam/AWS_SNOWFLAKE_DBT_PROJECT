



SELECT *
FROM AIRBNB.staging.listings



WHERE CREATED_AT > (
    SELECT COALESCE(
        MAX(CREATED_AT),
        '1900-01-01'::date
    )
    FROM AIRBNB.bronze.bronze_listings
)

