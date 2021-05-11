SELECT
    provider_id,
    hospital_name,
    provider_type,
    AVG(count_services) AS average_services,
    AVG(count_beneficiaries) AS average_beneficiaries,
    AVG(average_allowed) AS average_average_allowed,
    AVG(average_charged) AS average_average_charged,
    AVG(average_paid) AS average_average_paid
FROM {{ ref("12_physicians_hospital") }}
WHERE provider_id IS NOT NULL
GROUP BY provider_id, hospital_name, provider_type
