SELECT *
FROM {{ ref('06_physicians_2012')}}
UNION ALL
SELECT *
FROM {{ ref('07_physicians_2013')}}
UNION ALL
SELECT *
FROM {{ ref('08_physicians_2014')}}
