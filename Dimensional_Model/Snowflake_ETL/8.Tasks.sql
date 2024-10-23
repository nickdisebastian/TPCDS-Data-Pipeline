-- Tasks for customer dimensions

create or replace task sf_tpcds.intermediate.merging_new_records_in_customer_snapshot
    warehouse = COMPUTE_WH
    schedule = 'USING CRON * 8 * * * UTC'
    as
merge into SF_TPCDS.INTERMEDIATE.CUSTOMER_SNAPSHOT t1
using TPCDS.RAW.CUSTOMER t2
on  t1.C_CUSTOMER_ID = t2.C_CUSTOMER_ID 
    and t1.C_CUSTOMER_SK = t2.C_CUSTOMER_SK
    and t1.C_LOGIN = t2.C_LOGIN
    and t1.C_BIRTH_DAY = t2.C_BIRTH_DAY 
    and t1.C_LAST_NAME = t2.C_LAST_NAME 
    and t1.C_BIRTH_YEAR = t2.C_BIRTH_YEAR
    and t1.C_FIRST_NAME = t2.C_FIRST_NAME
    and t1.C_SALUTATION = t2.C_SALUTATION
    and t1.C_BIRTH_MONTH = t2.C_BIRTH_MONTH
    and t1.C_BIRTH_COUNTRY = t2.C_BIRTH_COUNTRY
    and t1.C_EMAIL_ADDRESS = t2.C_EMAIL_ADDRESS 
    and t1.C_CURRENT_ADDR_SK = t2.C_CURRENT_ADDR_SK
    and t1.C_CURRENT_CDEMO_SK = t2.C_CURRENT_CDEMO_SK
    and t1.C_CURRENT_HDEMO_SK = t2.C_CURRENT_HDEMO_SK
    and t1.C_FIRST_SALES_DATE_SK = t2.C_FIRST_SALES_DATE_SK
    and t1.C_LAST_REVIEW_DATE_SK = t2.C_LAST_REVIEW_DATE_SK
    and t1.C_PREFERRED_CUST_FLAG = t2.C_PREFERRED_CUST_FLAG 
    and t1.C_FIRST_SHIPTO_DATE_SK = t2.C_FIRST_SHIPTO_DATE_SK
when not matched
then insert (
    C_CUSTOMER_ID, 
    C_CUSTOMER_SK, 
    C_LOGIN, 
    C_BIRTH_DAY, 
    C_LAST_NAME, 
    C_BIRTH_YEAR, 
    C_FIRST_NAME, 
    C_SALUTATION, 
    C_BIRTH_MONTH, 
    C_BIRTH_COUNTRY, 
    C_EMAIL_ADDRESS, 
    C_CURRENT_ADDR_SK, 
    C_CURRENT_CDEMO_SK, 
    C_CURRENT_HDEMO_SK, 
    C_FIRST_SALES_DATE_SK, 
    C_LAST_REVIEW_DATE_SK, 
    C_PREFERRED_CUST_FLAG, 
    C_FIRST_SHIPTO_DATE_SK, 
    START_DATE, 
    END_DATE)
values (
    t2.C_CUSTOMER_ID, 
    t2.C_CUSTOMER_SK, 
    t2.C_LOGIN, 
    t2.C_BIRTH_DAY, 
    t2.C_LAST_NAME, 
    t2.C_BIRTH_YEAR, 
    t2.C_FIRST_NAME, 
    t2.C_SALUTATION, 
    t2.C_BIRTH_MONTH, 
    t2.C_BIRTH_COUNTRY, 
    t2.C_EMAIL_ADDRESS, 
    t2.C_CURRENT_ADDR_SK, 
    t2.C_CURRENT_CDEMO_SK, 
    t2.C_CURRENT_HDEMO_SK, 
    t2.C_FIRST_SALES_DATE_SK, 
    t2.C_LAST_REVIEW_DATE_SK, 
    t2.C_PREFERRED_CUST_FLAG, 
    t2.C_FIRST_SHIPTO_DATE_SK, 
    current_date(),
    null);

create or replace task sf_tpcds.intermediate.updating_old_records_in_customer_snapshot
    warehouse = COMPUTE_WH
    AFTER merging_new_records_in_customer_snapshot
    AS
merge into SF_TPCDS.INTERMEDIATE.CUSTOMER_SNAPSHOT t1
using TPCDS.RAW.CUSTOMER t2
on t1.customer_sk = t2.customer_sk
when matched
    and (
    t1.C_CUSTOMER_ID != t2.C_CUSTOMER_ID 
    and t1.C_LOGIN != t2.C_LOGIN
    and t1.C_BIRTH_DAY != t2.C_BIRTH_DAY 
    and t1.C_LAST_NAME != t2.C_LAST_NAME 
    and t1.C_BIRTH_YEAR != t2.C_BIRTH_YEAR
    and t1.C_FIRST_NAME != t2.C_FIRST_NAME
    and t1.C_SALUTATION != t2.C_SALUTATION
    and t1.C_BIRTH_MONTH != t2.C_BIRTH_MONTH
    and t1.C_BIRTH_COUNTRY != t2.C_BIRTH_COUNTRY
    and t1.C_EMAIL_ADDRESS != t2.C_EMAIL_ADDRESS 
    and t1.C_CURRENT_ADDR_SK != t2.C_CURRENT_ADDR_SK
    and t1.C_CURRENT_CDEMO_SK != t2.C_CURRENT_CDEMO_SK
    and t1.C_CURRENT_HDEMO_SK != t2.C_CURRENT_HDEMO_SK
    and t1.C_FIRST_SALES_DATE_SK != t2.C_FIRST_SALES_DATE_SK
    and t1.C_LAST_REVIEW_DATE_SK != t2.C_LAST_REVIEW_DATE_SK
    and t1.C_PREFERRED_CUST_FLAG != t2.C_PREFERRED_CUST_FLAG 
    and t1.C_FIRST_SHIPTO_DATE_SK != t2.C_FIRST_SHIPTO_DATE_SK
    )
then update set
    end_date = current_date();

create or replace task sf_tpcds.intermediate.creating_customer_dimension
    warehouse = COMPUTE_WH
    AFTER updating_old_records_in_customer_snapshot
    AS
create or replace table SF_TPCDS.ANALYTICS.CUSTOMER_DIM as (
    select
    C_LOGIN, 
    C_BIRTH_DAY, 
    C_LAST_NAME, 
    C_BIRTH_YEAR, 
    C_FIRST_NAME, 
    C_SALUTATION, 
    C_BIRTH_MONTH, 
    C_CUSTOMER_ID, 
    C_CUSTOMER_SK, 
    C_BIRTH_COUNTRY, 
    C_EMAIL_ADDRESS, 
    C_CURRENT_ADDR_SK, 
    C_CURRENT_CDEMO_SK, 
    C_CURRENT_HDEMO_SK, 
    C_FIRST_SALES_DATE_SK, 
    C_LAST_REVIEW_DATE_SK, 
    C_PREFERRED_CUST_FLAG, 
    C_FIRST_SHIPTO_DATE_SK, 
    CA_ZIP, 
    CA_CITY, 
    CA_STATE, 
    CA_COUNTY, 
    CA_COUNTRY, 
    CA_ADDRESS_ID, 
    CA_ADDRESS_SK, 
    CA_GMT_OFFSET, 
    CA_STREET_NAME, 
    CA_STREET_TYPE, 
    CA_SUITE_NUMBER, 
    CA_LOCATION_TYPE, 
    CA_STREET_NUMBER, 
    CD_GENDER, 
    CD_DEMO_SK, 
    CD_DEP_COUNT, 
    CD_CREDIT_RATING, 
    CD_MARITAL_STATUS, 
    CD_EDUCATION_STATUS, 
    CD_DEP_COLLEGE_COUNT, 
    CD_PURCHASE_ESTIMATE, 
    CD_DEP_EMPLOYED_COUNT, 
    HD_DEMO_SK, 
    HD_DEP_COUNT, 
    HD_BUY_POTENTIAL, 
    HD_VEHICLE_COUNT, 
    HD_INCOME_BAND_SK, 
    IB_LOWER_BOUND, 
    IB_UPPER_BOUND, 
    IB_INCOME_BAND_SK, 
    START_DATE, 
    END_DATE
from SF_TPCDS.INTERMEDIATE.CUSTOMER_SNAPSHOT
inner join TPCDS.RAW.CUSTOMER_ADDRESS on c_current_addr_sk = ca_address_sk
inner join TPCDS.RAW.CUSTOMER_DEMOGRAPHICS on c_current_cdemo_sk = cd_demo_sk
inner join TPCDS.RAW.HOUSEHOLD_DEMOGRAPHICS on c_current_hdemo_sk = hd_demo_sk
inner join TPCDS.RAW.INCOME_BAND on hd_income_band_sk = ib_income_band_sk);

SHOW TASKS:
ALTER TASK creating_customer_dimension RESUME;
ALTER TASK updating_old_records_in_customer_snapshot RESUME;
ALTER TASK merging_new_records_in_customer_snapshot RESUME;

-- Cleanup
ALTER TASK merging_new_records_in_customer_snapshot SUSPEND;
DROP TASK creating_customer_dimension;
DROP TASK updating_old_records_in_customer_snapshot;
DROP TASK merging_new_records_in_customer_snapshot;

