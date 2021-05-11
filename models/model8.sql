SELECT *
FROM {{ ref('model5')}}
UNION ALL
SELECT *
FROM {{ ref('model6')}}
UNION ALL
SELECT *
FROM {{ ref('model7')}}
