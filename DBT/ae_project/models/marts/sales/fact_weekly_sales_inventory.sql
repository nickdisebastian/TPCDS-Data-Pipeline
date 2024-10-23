
{{
    config(
        materialized = 'incremental',
        unique_key = ['warehouse_sk', 'item_sk', 'sold_date_sk']
    )
}}

with aggregating_daily_sales_to_week as(
select
    warehouse_sk,
    item_sk,
    max(sold_date_sk) as sold_wk_sk,
    sold_wk_num,
    sold_yr_num,
    sold_yr_wk_num,
    sum(daily_qty) as sum_qty_wk,
    sum(daily_sales_amt) as sum_amt_wk,
    sum(daily_profit) as sum_profit_wk
from
    {{ref('int_sales__daily_sales')}}
group by 1,2,4,5,6
)
select
    t1.warehouse_sk,
    t1.item_sk,
    max(sold_wk_sk) as sold_wk_sk,
    sold_wk_num,
    sold_yr_num,
    sold_yr_wk_num,
    sum(sum_qty_wk) as sum_qty_wk,
    sum(sum_amt_wk) as sum_amt_wk,
    sum(sum_profit_wk) as sum_profit_wk,
    sum(sum_qty_wk)/7 as avg_qty_dy,
    sum(coalesce(inv.quantity_on_hand,0)) as inv_qty_wk,
    sum(coalesce(inv.quantity_on_hand,0))/ sum(sum_qty_wk) as wks_sply,
    case when avg_qty_dy>0 and avg_qty_dy>inv_qty_wk then true else false end as low_stock_flg_wk
from aggregating_daily_sales_to_week t1
left join {{ref ('stg_tpcds__inventory')}} inv
    on inv.date_sk = t1.sold_wk_sk 
    and inv.item_sk = t1.item_sk 
    and inv.warehouse_sk = t1.warehouse_sk
group by 1,2,4,5,6
having sum(sum_qty_wk) > 0
{% if is_incremental() %}
and sold_wk_sk >= (select max (nvl(sold_wk_sk , 0)) from {{this}})
{% endif %}
