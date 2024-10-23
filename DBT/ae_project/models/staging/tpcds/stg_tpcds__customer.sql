select
    _AIRBYTE_EXTRACTED_AT, 
    C_LOGIN as login, 
    C_BIRTH_DAY as birth_day, 
    C_LAST_NAME as last_name, 
    C_BIRTH_YEAR as birth_year, 
    C_FIRST_NAME as first_name, 
    C_SALUTATION as salutation, 
    C_BIRTH_MONTH as birth_month, 
    C_CUSTOMER_ID as customer_id, 
    C_CUSTOMER_SK as customer_sk, 
    C_BIRTH_COUNTRY as birth_country, 
    C_EMAIL_ADDRESS as email_address, 
    C_CURRENT_ADDR_SK as current_addr_sk, 
    C_CURRENT_CDEMO_SK as current_cdemo_sk, 
    C_CURRENT_HDEMO_SK as current_hdemo_sk, 
    C_FIRST_SALES_DATE_SK as first_sales_date_sk, 
    C_LAST_REVIEW_DATE_SK as last_review_date_sk, 
    C_PREFERRED_CUST_FLAG as preferred_cust_flag, 
    C_FIRST_SHIPTO_DATE_SK as first_shipto_date_sk
from
    {{source('tpcds','customer')}}