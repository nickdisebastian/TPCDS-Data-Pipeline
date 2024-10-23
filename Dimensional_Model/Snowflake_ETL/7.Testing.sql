-- Customer Dimension
select count(*) = 0 from SF_TPCDS.ANALYTICS.CUSTOMER_DIM
where c_customer_sk is null;

-- weekly sales inventory
-- warehouse_sk, item_sk, and sold_wk_sk is unique
select count(*) = 0 from
    (select
        warehouse_sk, item_sk, sold_wk_sk
    from SF_TPCDS.ANALYTICS.WEEKLY_SALES_INVENTORY
    group by 1,2,3
    having count(*) >1);

-- relationship test
select count(*) = 0 from
    (select
        dim.i_item_sk
    from SF_TPCDS.ANALYTICS.WEEKLY_SALES_INVENTORY fact
    left join TPCDS.RAW.ITEM dim
    on dim.i_item_sk = fact.item_sk
    where dim.i_item_sk is null);