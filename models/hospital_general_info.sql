{{ config(materialized='table') }}
/*{{ config(materialized='incremental') }}*/
SELECT * FROM {{ source("cms_medicare", "hospital_general_info") }}
