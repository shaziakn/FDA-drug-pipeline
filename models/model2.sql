SELECT hospital_general_info.patient_experience_national_comparison,
        avg(inpatient.average_total_payments) as total,
        avg(inpatient.average_covered_charges) as covered,
        avg(inpatient.average_medicare_payments) as medicare
FROM {{ ref("model1") }} inpatient
JOIN {{ ref("hospital_general_info") }} hospital_general_info
ON inpatient.provider_id = hospital_general_info.provider_id
GROUP BY hospital_general_info.patient_experience_national_comparison
ORDER BY total DESC
