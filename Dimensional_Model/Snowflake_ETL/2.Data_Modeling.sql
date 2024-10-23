--1. Business Requirements
-- Create a new fact table with several new metrics:
    -- sum_qty_wk: the sum sales_quantity of this week
        -- sum(catalog_sales.cs_quantity) group by date_dim.week_num, item UNION same from web_sales
    -- sum_amt_wk: the sum sales_amount of this week
        -- sum(catalog_sales.cs_quantity*catalog_sales.cs_sales_price) group by date_dim.week_num, item         UNION same from web_sales
    -- sum_profit_wk: the sum net_profit of this week
        -- sum(catalog_sales.cs_net_profit) group by date_dim.week_num
    -- avg_qty_dy: the average daily sales_quantity of this week 
        -- sum_qty_wk/7
    -- inv_on_hand_qty_wk: the item’s inventory on hand at the end of each week in all warehouses 
        -- sum(inventory.quantity_on_hand) group by warehouse, week, item
    -- wks_sply: Weeks of supply, an estimate metrics to see how many weeks the inventory can supply            the sales
    -- inv_on_hand_qty_wk/sum_qty_wk
    -- low_stock_flg_wk: Low stock weekly flag. During the week, if there is a single day, if                   [(avg_qty_dy > 0 && ((avg_qty_dy) > (inventory_on_hand_qty_wk)), then the flag is True.
-- Integrate Customer Dimension (Snowflake to Star schema): Customer (SCD Type 2) + Customer_Address +      Customer_Demographics + Household_Demographics + Income_Band


-- 2. Data Model
-- Weekly Sales Inventory Fact Table
    -- Dimensions: week_num, item, warehouse, 
    -- Facts: sum_qty_week, sum_amt_wk, sum_profit_wk, avg_qty_dy, inv_on_hand_qty_wk, wks_sply,               low_stock_flg_wk
    
-- Customer Dimensions
-- Customer
C_LOGIN, C_BIRTH_DAY, C_LAST_NAME, C_BIRTH_YEAR, C_FIRST_NAME, C_SALUTATION, C_BIRTH_MONTH, C_CUSTOMER_ID, C_CUSTOMER_SK, C_BIRTH_COUNTRY, C_EMAIL_ADDRESS, C_CURRENT_ADDR_SK, C_CURRENT_CDEMO_SK, C_CURRENT_HDEMO_SK, C_FIRST_SALES_DATE_SK, C_LAST_REVIEW_DATE_SK, C_PREFERRED_CUST_FLAG, C_FIRST_SHIPTO_DATE_SK

-- Customer Address
CA_ZIP, CA_CITY, CA_STATE, CA_COUNTY, CA_COUNTRY, CA_ADDRESS_ID, CA_ADDRESS_SK, CA_GMT_OFFSET, CA_STREET_NAME, CA_STREET_TYPE, CA_SUITE_NUMBER, CA_LOCATION_TYPE, CA_STREET_NUMBER

-- Customer Demographics
CD_GENDER, CD_DEMO_SK, CD_DEP_COUNT, CD_CREDIT_RATING, CD_MARITAL_STATUS, CD_EDUCATION_STATUS, CD_DEP_COLLEGE_COUNT, CD_PURCHASE_ESTIMATE, CD_DEP_EMPLOYED_COUNT

-- Household Demographics
CD_GENDER, CD_DEMO_SK, CD_DEP_COUNT, CD_CREDIT_RATING, CD_MARITAL_STATUS, CD_EDUCATION_STATUS, CD_DEP_COLLEGE_COUNT, CD_PURCHASE_ESTIMATE, CD_DEP_EMPLOYED_COUNT

-- Income Band
IB_LOWER_BOUND, IB_UPPER_BOUND, IB_INCOME_BAND_SK

-- SCD Type 2
Valid From, Valid To

