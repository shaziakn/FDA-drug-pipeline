SELECT provider_type, COUNT(provider_type) AS count
FROM {{ ref('14_services_ranked') }}
WHERE services_rank = 1
GROUP BY provider_type
ORDER BY count DESC
