-- define last date
set last_sold_wk_sk = (select max(sold_wk_sk) from SF_TPCDS.ANALYTICS.WEEKLY_SALES_INVENTORY);

-- remove partial records from last date
delete from SF_TPCDS.ANALYTICS.WEEKLY_SALES_INVENTORY where sold_wk_sk = $last_sold_wk_sk;

-- compiling all incremental sales records
create or replace transient table SF_TPCDS.INTERMEDIATE.WEEKLY_SALES_INVENTORY AS (
with aggregating_daily_sales_to_week as(
select
    warehouse_sk,
    item_sk,
    max(sold_date_sk) as sold_wk_sk,
    sold_wk_num,
    sold_yr_num,
    sum(daily_qty) as sum_qty_wk,
    sum(daily_sales_amt) as sum_amt_wk,
    sum(daily_profit) as sum_profit_wk
from
    sf_tpcds.intermediate.daily_aggregated_sales
group by 1,2,4,5
having sold_wk_sk >= nvl($last_sold_wk_sk,0)
)
select
    warehouse_sk,
    item_sk,
    max(sold_wk_sk) as sold_wk_sk,
    sold_wk_num,
    sold_yr_num,
    sum(sum_qty_wk) as sum_qty_wk,
    sum(sum_amt_wk) as sum_amt_wk,
    sum(sum_profit_wk) as sum_profit_wk,
    sum(sum_qty_wk)/7 as avg_qty_dy,
    sum(coalesce(inv.inv_quantity_on_hand,0)) as inv_qty_wk,
    sum(coalesce(inv.inv_quantity_on_hand,0))/ sum(sum_qty_wk) as wks_sply,
    case when avg_qty_dy>0 and avg_qty_dy>inv_qty_wk then true else false end as low_stock_flg_wk
from aggregating_daily_sales_to_week
left join TPCDS.RAW.INVENTORY inv
    on inv_date_sk = sold_wk_sk 
    and item_sk = inv_item_sk 
    and inv_warehouse_sk = warehouse_sk
group by 1,2,4,5
having sum(sum_qty_wk) > 0
);

-- inserting new records
insert into SF_TPCDS.ANALYTICS.WEEKLY_SALES_INVENTORY (
    WAREHOUSE_SK, 
    ITEM_SK, 
    SOLD_WK_SK, 
    SOLD_WK_NUM, 
    SOLD_YR_NUM, 
    SUM_QTY_WK, 
    SUM_AMT_WK, 
    SUM_PROFIT_WK, 
    AVG_QTY_DY, 
    INV_QTY_WK, 
    WKS_SPLY, 
    LOW_STOCK_FLG_WK)
select 
    distinct WAREHOUSE_SK, 
    ITEM_SK, 
    SOLD_WK_SK, 
    SOLD_WK_NUM, 
    SOLD_YR_NUM, 
    SUM_QTY_WK, 
    SUM_AMT_WK, 
    SUM_PROFIT_WK, 
    AVG_QTY_DY, 
    INV_QTY_WK, 
    WKS_SPLY, 
    LOW_STOCK_FLG_WK
from SF_TPCDS.INTERMEDIATE.WEEKLY_SALES_INVENTORY;

