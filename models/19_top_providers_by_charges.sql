SELECT provider_type, COUNT(provider_type) AS count
FROM {{ ref('18_avg_charges_ranked') }}
WHERE charges_rank = 1
GROUP BY provider_type
ORDER BY count DESC
