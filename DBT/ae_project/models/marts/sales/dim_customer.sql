{{
    config(
        materialized = 'incremental',
        unique_key = ['customer_sk']
    )
}}

select
    cs.*,
    ca.ZIP, 
    ca.CITY, 
    ca.STATE, 
    ca.COUNTY, 
    ca.COUNTRY, 
    ca.ADDRESS_ID, 
    ca.GMT_OFFSET, 
    ca.STREET_NAME, 
    ca.STREET_TYPE, 
    ca.SUITE_NUMBER, 
    ca.LOCATION_TYPE, 
    ca.STREET_NUMBER,
    cd.GENDER,  
    cd.DEP_COUNT, 
    cd.CREDIT_RATING, 
    cd.MARITAL_STATUS, 
    cd.EDUCATION_STATUS, 
    cd.DEP_COLLEGE_COUNT, 
    cd.PURCHASE_ESTIMATE, 
    cd.DEP_EMPLOYED_COUNT,
    hd.DEP_COUNT as HH_DEP_COUNT, 
    hd.BUY_POTENTIAL, 
    hd.VEHICLE_COUNT, 
    hd.INCOME_BAND_SK as HH_INCOME_BAND_SK,
    ib.LOWER_BOUND, 
    ib.UPPER_BOUND
from   
    {{ref('customer_snapshot')}} as cs
    left join {{ref('stg_tpcds__customer_address')}} as ca on ca.address_sk = cs.current_addr_sk
    left join {{ref('stg_tpcds__customer_demographics')}} as cd on cd.demo_sk = cs.current_cdemo_sk
    left join {{ref('stg_tpcds__household_demographics')}} as hd on hd.demo_sk = cs.current_hdemo_sk
    left join {{ref('stg_tpcds__income_band')}} as ib on ib.income_band_sk = hd.income_band_sk
where cs.dbt_valid_from is null
