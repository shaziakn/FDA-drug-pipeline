SELECT *, RANK() OVER (PARTITION BY provider_id ORDER BY average_services DESC) AS services_rank
FROM {{ ref('model12') }}
