SELECT hospitals.*, {{ dbt_utils.star(from=ref("10_clean_physicians_all"), except=['city', 'state']) }}
FROM {{ ref("10_clean_physicians_all") }} providers
LEFT OUTER JOIN {{ ref("11_clean_hospital_general_info") }} hospitals
ON SUBSTR(providers.zip, 1, 5) = hospitals.zip_code
AND providers.city = hospitals.city
AND REGEXP_SUBSTR(providers.abbr_street, r"\S+", 1, 1) = REGEXP_SUBSTR(hospitals.abbr_address, r"\S+", 1, 1)
AND REGEXP_SUBSTR(providers.abbr_street, r"\S+", 1, 2) = REGEXP_SUBSTR(hospitals.abbr_address, r"\S+", 1, 2)
