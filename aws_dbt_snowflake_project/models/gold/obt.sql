{% set configs = [
    {
        "table": ref('silver_bookings'),
        "columns": "b.*",
        "alias": "b"
    },
    {
        "table": ref('silver_listings'),
        "columns": "l.HOST_ID, l.PROPERTY_TYPE, l.ROOM_TYPE, l.CITY, l.COUNTRY, l.ACCOMMODATES, l.BEDROOMS, l.BATHROOMS, l.PRICE_PER_NIGHT, l.PRICE_TAG, l.CREATED_AT AS LISTING_CREATED_AT",
        "alias": "l",
        "join_condition": "b.LISTING_ID = l.LISTING_ID"
    },
    {
        "table": ref('silver_hosts'),
        "columns": "h.HOST_NAME, h.IS_SUPERHOST, h.RESPONSE_RATE, h.CREATED_AT AS HOST_CREATED_AT",
        "alias": "h",
        "join_condition": "l.HOST_ID = h.HOST_ID"
    }
] %}



SELECT
    {% for config in configs %}
        {{ config['columns'] }}{% if not loop.last %},{% endif %}
    {% endfor %}

FROM
    {% for config in configs %}

        {% if loop.first %}

            {{ config['table'] }} AS {{ config['alias'] }}

        {% else %}

            LEFT JOIN {{ config['table'] }} AS {{ config['alias'] }}
                ON {{ config['join_condition'] }}

        {% endif %}

    {% endfor %}