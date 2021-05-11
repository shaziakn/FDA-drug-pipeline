SELECT provider_type, COUNT(provider_type) AS count
FROM {{ ref('model13') }}
WHERE services_rank = 1
GROUP BY provider_type
ORDER BY count DESC
