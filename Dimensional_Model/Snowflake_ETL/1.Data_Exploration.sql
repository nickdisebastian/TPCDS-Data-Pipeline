-- The earliest and latest date of fact tables
select  d_date_sk, cal_dt from date_dim limit 100; -- d_date_sk increases incrementally with cal_dt

-- Date range of Catalog Sales
select cal_dt from date_dim where d_date_sk = (select min(cs_sold_date_sk) from catalog_sales); -- 2021-01-01
select cal_dt from date_dim where d_date_sk = (select max(cs_sold_date_sk) from catalog_sales);-- 2024-09-13

-- Date range of Inventory
select cal_dt from date_dim where d_date_sk = (select min(inv_date_sk) from inventory); -- 2021-01-01
select cal_dt from date_dim where d_date_sk = (select max(inv_date_sk) from inventory);-- 2024-09-24

-- How frequently do we recieve data in fact tables
-- web_sales
select 
    ws.ws_sold_date_sk,
    d.cal_dt,
    count(*)
from web_sales ws
join date_dim d on ws.ws_sold_date_sk = d.d_date_sk
group by 1,2
order by 2
limit 10; -- About 200 records daily

-- Row numbers of each table

-- Verify connection to date_dim using cs_sold_date_sk
select
    fact.cs_sold_date_sk,
    date_dim.*
from TPCDS.RAW.CATALOG_SALES as fact
inner join TPCDS.RAW.DATE_DIM as dim
    on dim.d_date_sk = fact.cs_sold_date_sk
limit 5;

-- Verify connections between tables
-- Example: Verify connection to time_dim using cd_sold_time_sk
select
    fact.cs_sold_time_sk,
    time_dim.*
from TPCDS.RAW.CATALOG_SALES as fact
inner join TPCDS.RAW.TIME_DIM as dim
    on dim.t_time_sk = fact.cs_sold_time_sk
limit 5;

-- Identify random item that exists repeatedly in inventory table
select
    inv_date_sk,
    inv_item_sk,
    count(*) as count
from TPCDS.RAW.INVENTORY
group by 1,2
order by 2,1;


