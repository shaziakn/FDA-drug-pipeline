SELECT provider_type, COUNT(provider_type) AS count
FROM {{ ref('model17') }}
WHERE charges_rank = 1
GROUP BY provider_type
ORDER BY count DESC
