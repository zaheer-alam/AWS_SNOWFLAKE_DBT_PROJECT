{% set nights_booked = 1%}
{% set flag = 2%}
{% set cols = ['BOOKING_ID', 'NIGHTS_BOOKED', 'BOOKING_AMOUNT'] %}

{# select * from {{ ref('bronze_bookings') }} 
where nights_booked > {{ nights_booked }} #}

{# select * from {{ ref('bronze_bookings')}} 
{% if flag  == 1%}
where nights_booked > 1
{% else %}
where nights_booked = 1
{% endif %} #}

select
{% for col in cols%}
    {{col}}
    {% if not loop.last %},
    {% endif %}
{% endfor %}
from {{ ref('bronze_bookings')}}