{% macro trimmer(col_name) %}
    INITCAP(TRIM({{ col_name }}))
{% endmacro %}