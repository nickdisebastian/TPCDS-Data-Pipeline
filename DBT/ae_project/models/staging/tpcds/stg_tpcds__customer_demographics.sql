select
    _AIRBYTE_EXTRACTED_AT,
    CD_GENDER as gender,
    CD_DEMO_SK as demo_sk,
    CD_DEP_COUNT as dep_count,
    CD_CREDIT_RATING as credit_rating,
    CD_MARITAL_STATUS as marital_status,
    CD_EDUCATION_STATUS as education_status,
    CD_DEP_COLLEGE_COUNT as dep_college_count,
    CD_PURCHASE_ESTIMATE as purchase_estimate,
    CD_DEP_EMPLOYED_COUNT as dep_employed_count
from 
    {{ source('tpcds', 'customer_demographics') }}