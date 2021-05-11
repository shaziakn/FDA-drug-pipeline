SELECT *, RANK() OVER (PARTITION BY provider_id ORDER BY average_average_charged DESC) AS charges_rank
FROM {{ ref('13_aggregate') }}
