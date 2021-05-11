SELECT hospitals.*, {{ dbt_utils.star(from=ref("model9"), except=['city', 'state']) }}
FROM {{ ref("model9") }} providers
LEFT OUTER JOIN {{ ref("model10") }} hospitals
ON SUBSTR(providers.zip, 1, 5) = hospitals.zip_code
AND REGEXP_SUBSTR(providers.abbr_street, r"\S+", 1, 2) = REGEXP_SUBSTR(hospitals.abbr_address, r"\S+", 1, 2)
