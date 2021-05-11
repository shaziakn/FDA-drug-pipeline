SELECT provider_type, COUNT(provider_type) AS count
FROM {{ ref('model15') }}
WHERE beneficiaries_rank = 1
GROUP BY provider_type
ORDER BY count DESC
