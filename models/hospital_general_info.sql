/*{{ config(materialized='incremental') }}*/
{{ config(materialized='table') }}

SELECT * FROM {{ source("cms_medicare", "hospital_general_info") }}
