SELECT *
FROM {{ source('cms_medicare', 'inpatient_charges_2012')}}
UNION ALL
SELECT *
FROM {{ source('cms_medicare', 'inpatient_charges_2013')}}
UNION ALL
SELECT *
FROM {{ source('cms_medicare', 'inpatient_charges_2014')}}
