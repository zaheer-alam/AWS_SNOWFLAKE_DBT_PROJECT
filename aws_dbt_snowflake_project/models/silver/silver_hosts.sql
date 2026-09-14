{{ config(
    materialized = "incremental",
    keys = 'HOST_ID'
) }}    

SELECT
    HOST_ID,
    {{trimmer('HOST_NAME')}} AS HOST_NAME,
    IS_SUPERHOST,
    RESPONSE_RATE,
    CREATED_AT
FROM 
    {{ref('bronze_hosts')}}
    