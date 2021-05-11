SELECT provider_type, COUNT(provider_type) AS count
FROM {{ ref('16_services_used_ranked') }}
WHERE beneficiaries_rank = 1
GROUP BY provider_type
ORDER BY count DESC
