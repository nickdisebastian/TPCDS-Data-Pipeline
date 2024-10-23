-- define last date
set last_sold_date_sk = (select max(sold_date_sk) from SF_TPCDS.INTERMEDIATE.DAILY_AGGREGATED_SALES);

-- remove partial records from last date
delete from SF_TPCDS.INTERMEDIATE.DAILY_AGGREGATED_SALES where sold_date_sk = $last_sold_date_sk;

-- compiling all incremental sales records
create or replace temporary table SF_TPCDS.INTERMEDIATE.DAILY_AGGREGATED_SALES_TMP AS(
with incremental_sales as(
    select
        cs_warehouse_sk as warehouse_sk,
        cs_item_sk as item_sk,
        cs_sold_date_sk as sold_date_sk,
        cs_quantity as quantity,
        cs_sales_price * cs_quantity as sales_amt,
        cs_net_profit as net_profit
    from TPCDS.RAW.CATALOG_SALES
    where cs_sold_date_sk >= nvl($last_sold_date_sk,0)
        and cs_quantity is not null
    union
    select
        ws_warehouse_sk as warehouse_sk,
        ws_item_sk as item_sk,
        ws_sold_date_sk as sold_date_sk,
        ws_quantity as quantity,
        ws_sales_price * ws_quantity as sales_amt,
        ws_net_profit as net_profit
    from TPCDS.RAW.WEB_SALES
    where ws_sold_date_sk >= nvl($last_sold_date_sk,0)
        and ws_quantity is not null),
        
aggregating_records_to_daily_sales as (
    select 
        warehouse_sk,
        item_sk,
        sold_date_sk,
        sum(quantity) as daily_qty,
        sum(sales_amt) as daily_sales_amt,
        sum(net_profit) as daily_profit
    from incremental_sales
    group by 1,2,3),
    
adding_week_number_and_yr_number as (
    select
        *,
        d.wk_num as sold_wk_num,
        d.yr_num as sold_yr_num
    from aggregating_records_to_daily_sales
    LEFT JOIN TPCDS.RAW.DATE_DIM d
        on sold_Date_sk = d.d_date_sk
)

select 
    warehouse_sk,
    item_sk,
    sold_date_sk,
    max(sold_wk_num) as sold_wk_num,
    max(sold_yr_num) as sold_yr_num,
    sum(daily_qty) as daily_qty,
    sum(daily_sales_amt) as daily_sales_amt,
    sum(daily_profit) as daily_profit
from adding_week_number_and_yr_number
group by 1,2,3);

insert into SF_TPCDS.INTERMEDIATE.DAILY_AGGREGATED_SALES(
    WAREHOUSE_SK, 
    ITEM_SK, 
    SOLD_DATE_SK, 
    SOLD_WK_NUM, 
    SOLD_YR_NUM, 
    DAILY_QTY, 
    DAILY_SALES_AMT, 
    DAILY_PROFIT
)
select 
    distinct WAREHOUSE_SK, 
    ITEM_SK, 
    SOLD_DATE_SK, 
    SOLD_WK_NUM, 
    SOLD_YR_NUM, 
    DAILY_QTY, 
    DAILY_SALES_AMT, 
    DAILY_PROFIT
from SF_TPCDS.INTERMEDIATE.DAILY_AGGREGATED_SALES_TMP;


