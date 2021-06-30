## Value-Based Care: Findings from CMS Medicare Data

### Overview

Research has shown that the cost of receiving medical care is increasing across the United States. According to the Centers for Medicare and Medicaid Services (CMS), a government agency responsible for managing two of the largest sources of health insurance in the U.S., healthcare spending reached $3.8 trillion in 2019, a 4.6% increase from 2018 [1]. On a per capita basis, health spending increased about six-fold in the last four decades, from approximately $1,850 per person in 1970 to $11,580 in 2019, adjusted for inflation [2].

One reason for the rapid increase in medical care costs lies within the United States’ primarily fee-for-service, or capitated, model of healthcare delivery [3]. Fee-for-service models pay healthcare providers based on the amount of services delivered, which can encourage providers to order services that may not be medically necessary. In response, some have proposed the implementation of a value-based model of healthcare. Value-based models pay healthcare providers by the value of services delivered, which some proponents argue will place a greater emphasis on the quality of patient care.

For this project, we are interested in examining the patterns in healthcare costs in the United States. We use Google BigQuery’s publicly available Medicare datasets because CMS is a large provider of healthcare funding. Specifically, we use seven datasets: one corresponding to general information about hospitals in the U.S., three corresponding to in-patient Medicare charges by hospital from 2012 to 2014, and three corresponding to Medicare utilization by provider from 2012 to 2014. See Figure 1 in the Appendix for an entity resolution diagram of the datasets. From this data, we posit the following questions:

How are in-patient reimbursement charges by the CMS associated with patient experiences at healthcare facilities in the U.S.?
Is the relationship between CMS in-patient reimbursement charges and patient experiences modified by the type of hospital ownership (e.g., public or private hospitals) and the state in which the hospital is located?
Which hospital departments incur the most CMS reimbursement charges, have the most Medicare beneficiaries, and provide the most Medicare services within a given hospital?

We hypothesize that healthcare facilities with higher-than-average scores in patient experience will tend to have lower in-patient reimbursement charges. We further hypothesize that publicly-owned hospitals will typically have higher in-patient reimbursement charges and patient experiences than privately-owned hospitals and that more diverse states like California and New York will also have higher in-patient reimbursement charges and patient experiences. Finally, we anticipate primary care departments will have the most Medicare beneficiaries and provide the most Medicare services within a given hospital while specialist departments will have the highest in-patient reimbursement charges.

### Model Structure

![alt text](https://github.com/shaziakn/medicare_pipeline/blob/add-practice-model/lineage_graph.png?raw=true)

From start to finish, the data pipeline took us six days to write. The pipeline took 21.49 seconds to run and the tests took 145.27 seconds to complete.
We built 19 models for our project, and our pipeline has a depth of seven. We began our pipeline with the seven datasets described in our Overview and have included snippets of the seven tables in the Appendix. Our pipeline can be divided into several discrete steps:

First, we materialized the hospital_general_info table as incremental since it is the only table that will be frequently updated for changing patient experiences in each hospital over time. See Figure 2 in the Appendix for an illustration of our model configuration.
Second, we stacked all inpatient_charges tables together using UNION into one view.
Third, we determined how costs were associated with patient experience in inpatient facilities through an INNER JOIN between inpatient_all and hospital_general_info.
We further stratified by hospital ownership and state to determine if these variables modified the relationship.
Fourth, we used GROUP BY and aggregation functions to extract relevant information from physicians_and_other_supplier tables.
Fifth, we stacked all physicians_and_other_supplier tables using UNION into one view.
Sixth, we abbreviated compass directions north, south, east, and west to N, S, E, and W, respectively, in our stacked table to prepare an OUTER JOIN between physicians_all and hospital_general_info. This was an attempt to match physicians to hospitals.
Seventh, we performed a LEFT OUTER JOIN between physicians_all and hospital_general_info on city, ZIP code, and street address. Physicians who were not matched to hospitals were assumed to work in private healthcare facilities not included in the hospital_general_info dataset.
Eighth, we aggregated by hospitals and provider type to obtain averages in the number of Medicare services offered, the number of Medicare beneficiaries served, and the amount of Medicare charges.
Ninth, we used window functions to rank provider types within each hospital by average number of Medicare services offered, average number of Medicare beneficiaries serviced, and average amount of Medicare charges.
Tenth, we created tables showing which departments had the highest average number of Medicare services offered, average number of Medicare beneficiaries serviced, and average amount of Medicare charges.

Descriptions have been added to the dbt spec for each of our models. Figure 3 in the Appendix represents a full lineage DAG of our models. Adding Steps 5 to 10 after cleaning hospital_general_info led to the pipeline’s depth of seven.

We implemented 41 tests to ensure that our data quality was maintained after each step. Three interesting data quality tests included:

Making sure the LEFT OUTER JOIN was completed successfully by referring to the physicians_all and hospital_general_info views, along with checking if their primary keys were included. We chose this test because we wanted to ensure that the correct views were being joined and that they were being joined by the correct columns.
Making sure the patient experience variable in hospital_general_info had accepted values from only four categories: “Above the National Comparison,” “Below the National Comparison,” “Same as the National Comparison,” and “Not Available”). We chose this test because this variable was fundamental to our first and second research questions.
Making sure provider ID for hospital_general_info was still the primary key after cleaning the address field. We chose this test because hospital_general_info needed to be accurate before the LEFT OUTER JOIN step.

### Interesting Findings

From our models, we observed that hospitals with patient experience ratings below the national comparison incurred more covered charges. Surprisingly, however, hospitals with patient experience ratings above the national comparison typically incurred more total payments and Medicare payments. One explanation for this finding is that recent Medicare policies reduce payments to hospitals that have higher Medicare readmission rates following previous hospitalizations [4]. Thus, hospitals with higher patient experience ratings may have fewer charges due to lower readmission rates while still receiving higher payments.

We also found that hospitals owned by state governments incurred the most total payments and Medicare payments regardless of patient experience. This was not surprising given that state hospitals are more likely to serve low-income beneficiaries and, thus, receive more payments from CMS. By state, Wyoming incurred the most total payments and Medicare payments with a patient experience of above the national comparison. Hawaii incurred the most covered charges with a patient experience rating above the national comparison.

Finally, we found that Diagnostic Radiology as a hospital department ranked highest in both the number of Medicare services provided and the number of Medicare beneficiaries served. Diagnostic Radiology was followed by Family Practice and Internal Medicine for both categories as well. Anesthesiology was, by far, the most common hospital department that had the highest in-patient reimbursement charges. These findings were not surprising given that diagnostic radiology, family medicine, and internal medicine are all considered primary care services, which are more widely accessible than specialty care. Anesthesiology, however, is an area of specialty care associated with surgical procedures and, thus, expected to cost more.

### Reflection

Overall, the outcomes of our pipeline did match our initial goals. Although we originally wanted to focus on healthcare charges, we were limited by the fact that only average charges were reported at the physician level. Thus, in order to ensure that our findings were interpretable and extrapolatable, we decided to additionally analyze the number of services offered and provided by physicians. If we had more time, we would have searched for another dataset with more granular reporting of healthcare charges — i.e., itemized lists of charges at the physician level — to supplement our findings and to better study our research questions.

Regarding our experience working with dbt, we felt the documentation was relatively straightforward, though it did take some time getting used to it. We would need to explore more use cases before considering it in the future.

Finally, if we had a graphical UI like Trifacta that would generate the SQL models and dbt specs, we feel the graphical UI would be most beneficial for visualizing relationships between relations. However, we would still like to write our own SQL models and dbt specs because we can better control the pipeline. For example, “intermediate” models in our pipeline may be useful for future analysis. By writing our own models and specs, we would be able to replicate our steps.

### Links to Code

pipeline:
https://github.com/shaziakn/medicare_pipeline

.dbt folder with keyfile and profiles.yml:
https://drive.google.com/drive/folders/1jfAJsWoIY3SlrhL4Xsq_MWskMpjH27yQ?usp=sharing 

### References

[1] Centers for Medicare and Medicaid Services, “National Health Expenditure Data” https://www.cms.gov/Research-Statistics-Data-and-Systems/Statistics-Trends-and-Reports/NationalHealthExpendData/NationalHealthAccountsHistorical
[2] R. Kamal, D. McDermott, G. Ramirez, C. Cox, “How has U.S. spending on healthcare changed over time?” https://www.healthsystemtracker.org/chart-collection/u-s-spending-healthcare-changed-time/
[3] NEJM Catalyst, “What Is Value-Based Healthcare?” https://catalyst.nejm.org/doi/full/10.1056/CAT.17.0558
[4] J. Cubanski, C. Swoope, C. Boccuti, G. Jacobson, G. Casillas, S. Griffin, T. Neuman, “A Primer on Medicare: Key Facts About the Medicare Program and the People it Covers” https://www.kff.org/report-section/a-primer-on-medicare-how-does-medicare-pay-providers-in-traditional-medicare/

### Sources

https://docs.getdbt.com/dbt-cli/configure-your-profile
https://docs.getdbt.com/docs/building-a-dbt-project/using-sources
https://docs.getdbt.com/docs/building-a-dbt-project/tests
https://docs.getdbt.com/tutorial/setting-up
https://docs.getdbt.com/tutorial/test-and-document-your-project
https://github.com/fishtown-analytics/dbt-starter-project

