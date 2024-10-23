create or replace database SF_TPCDS;

create or replace schema INTERMEDIATE;

-- create customer snapshot table
create or replace table sf_tpcds.intermediate.customer_snapshot(
    C_CUSTOMER_ID varchar(16777216), 
    C_CUSTOMER_SK number(38,0),
    C_LOGIN varchar(16777216), 
    C_BIRTH_DAY number(38,0), 
    C_LAST_NAME varchar(16777216), 
    C_BIRTH_YEAR number(38,0), 
    C_FIRST_NAME varchar(16777216), 
    C_SALUTATION varchar(16777216), 
    C_BIRTH_MONTH number(38,0),  
    C_BIRTH_COUNTRY varchar(16777216), 
    C_EMAIL_ADDRESS varchar(16777216), 
    C_CURRENT_ADDR_SK number(38,0), 
    C_CURRENT_CDEMO_SK number(38,0), 
    C_CURRENT_HDEMO_SK number(38,0), 
    C_FIRST_SALES_DATE_SK number(38,0), 
    C_LAST_REVIEW_DATE_SK number(38,0), 
    C_PREFERRED_CUST_FLAG varchar(16777216), 
    C_FIRST_SHIPTO_DATE_SK number(38,0),
    START_DATE timestamp_ntz(9),
    END_DATE timestamp_ntz(9)
);


create or replace schema analytics;

-- Final Customer Dimension Table
create or replace table sf_tpcds.analytics.customer_dim(
    C_LOGIN VARCHAR(16777216),
	C_BIRTH_DAY NUMBER(38,0),
	C_LAST_NAME VARCHAR(16777216),
	C_BIRTH_YEAR NUMBER(38,0),
	C_FIRST_NAME VARCHAR(16777216),
	C_SALUTATION VARCHAR(16777216),
	C_BIRTH_MONTH NUMBER(38,0),
	C_CUSTOMER_ID VARCHAR(16777216),
	C_CUSTOMER_SK NUMBER(38,0),
	C_BIRTH_COUNTRY VARCHAR(16777216),
	C_EMAIL_ADDRESS VARCHAR(16777216),
	C_CURRENT_ADDR_SK NUMBER(38,0),
	C_CURRENT_CDEMO_SK NUMBER(38,0),
	C_CURRENT_HDEMO_SK NUMBER(38,0),
	C_FIRST_SALES_DATE_SK NUMBER(38,0),
	C_LAST_REVIEW_DATE_SK NUMBER(38,0),
	C_PREFERRED_CUST_FLAG VARCHAR(16777216),
	C_FIRST_SHIPTO_DATE_SK NUMBER(38,0),
    CA_ZIP VARCHAR(16777216),
	CA_CITY VARCHAR(16777216),
	CA_STATE VARCHAR(16777216),
	CA_COUNTY VARCHAR(16777216),
	CA_COUNTRY VARCHAR(16777216),
	CA_ADDRESS_ID VARCHAR(16777216),
	CA_ADDRESS_SK NUMBER(38,0),
	CA_GMT_OFFSET FLOAT,
	CA_STREET_NAME VARCHAR(16777216),
	CA_STREET_TYPE VARCHAR(16777216),
	CA_SUITE_NUMBER VARCHAR(16777216),
	CA_LOCATION_TYPE VARCHAR(16777216),
	CA_STREET_NUMBER VARCHAR(16777216),
    CD_GENDER VARCHAR(16777216),
	CD_DEMO_SK NUMBER(38,0),
	CD_DEP_COUNT NUMBER(38,0),
	CD_CREDIT_RATING VARCHAR(16777216),
	CD_MARITAL_STATUS VARCHAR(16777216),
	CD_EDUCATION_STATUS VARCHAR(16777216),
	CD_DEP_COLLEGE_COUNT NUMBER(38,0),
	CD_PURCHASE_ESTIMATE NUMBER(38,0),
	CD_DEP_EMPLOYED_COUNT NUMBER(38,0),
    HD_DEMO_SK NUMBER(38,0),
	HD_DEP_COUNT NUMBER(38,0),
	HD_BUY_POTENTIAL VARCHAR(16777216),
	HD_VEHICLE_COUNT NUMBER(38,0),
	HD_INCOME_BAND_SK NUMBER(38,0),
    IB_LOWER_BOUND NUMBER(38,0),
	IB_UPPER_BOUND NUMBER(38,0),
	IB_INCOME_BAND_SK NUMBER(38,0),
    START_DATE timestamp_ntz(9),
    END_DATE timestamp_ntz(9));

create or replace table SF_TPCDS.ANALYTICS.weekly_sales_inventory(
    warehouse_sk number(38,0),
    item_sk number(38,0),
    sold_wk_sk number(38,0),
    sold_wk_num number(38,0),
    sold_yr_num number(38,0),
    sum_qty_wk number(38,0),
    sum_amt_wk float,
    sum_profit_wk float,
    avg_qty_dy number(38,6),
    inv_qty_wk number(38,0),
    wks_sply number (38,6),
    low_stock_flg_wk boolean
);

create or replace table SF_TPCDS.intermediate.daily_aggregated_sales(
    warehouse_sk number(38,0),
    item_sk number(38,0),
    sold_date_sk number(38,0),
    sold_wk_num number(38,0),
    sold_yr_num number(38,0),
    daily_qty number(38,0),
    daily_sales_amt float,
    daily_profit float);

    