



SELECT *
FROM AIRBNB.staging.hosts



WHERE CREATED_AT > (
    SELECT COALESCE(
        MAX(CREATED_AT),
        '1900-01-01'::date
    )
    FROM AIRBNB.bronze.bronze_hosts
)

