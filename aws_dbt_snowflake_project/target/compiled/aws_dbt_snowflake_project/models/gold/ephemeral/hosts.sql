

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