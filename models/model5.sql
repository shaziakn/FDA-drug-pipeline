SELECT 2012 AS year,
    npi,
    nppes_provider_last_org_name AS last_name,
    nppes_provider_first_name AS first_name,
    provider_type,
    nppes_provider_street1 AS street,
    nppes_provider_city AS city,
    MAX(nppes_provider_zip) AS zip,
    nppes_provider_state AS state,
    SUM(line_srvc_cnt) AS count_services,
    SUM(bene_unique_cnt) AS count_beneficiaries,
    AVG(average_medicare_allowed_amt) AS average_allowed,
    AVG(average_submitted_chrg_amt) AS average_charged,
    AVG(average_medicare_payment_amt) AS average_paid
FROM {{ source("cms_medicare", "physicians_and_other_supplier_2012")}}
WHERE nppes_entity_code = "I"
GROUP BY npi,
    last_name,
    first_name,
    provider_type,
    street,
    city,
    state
