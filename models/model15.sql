SELECT *, RANK() OVER (PARTITION BY provider_id ORDER BY average_beneficiaries DESC) AS beneficiaries_rank
FROM {{ ref('model12') }}
