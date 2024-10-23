
{{
    config(
        materialized = 'incremental',
        unique_key = ['warehouse_sk', 'item_sk', 'sold_date_sk']
    )
}}

with incremental_sales as(
    select
        warehouse_sk,
        item_sk,
        sold_date_sk,
        quantity,
        sales_price * quantity as sales_amt,
        net_profit
    from {{ref('stg_tpcds__catalog_sales')}}
    where 
        quantity is not null
        and sales_amt is not null
    union
    select
        warehouse_sk,
        item_sk,
        sold_date_sk,
        quantity,
        sales_price * quantity as sales_amt,
        net_profit
    from {{ref('stg_tpcds__web_sales')}}
    where 
        quantity is not null
        and sales_amt is not null
        ),
        
aggregating_records_to_daily_sales as (
    select 
        warehouse_sk,
        item_sk,
        sold_date_sk,
        sum(quantity) as daily_qty,
        sum(sales_amt) as daily_sales_amt,
        sum(net_profit) as daily_profit
    from incremental_sales
    group by 1,2,3)

select
    *,
    d.wk_num as sold_wk_num,
    d.yr_num as sold_yr_num,
    d.YR_WK_NUM as sold_yr_wk_num
from aggregating_records_to_daily_sales
LEFT JOIN {{ref('stg_tpcds__date_dim')}} as d 
    on sold_date_sk = d.date_sk
{% if is_incremental() %}
where sold_date_sk >= (select max (nvl(sold_date_sk , 0)) from {{this}})
{% endif %}