select
    INV_DATE_SK as date_sk, 
    INV_ITEM_SK as item_sk, 
    INV_QUANTITY_ON_HAND as quantity_on_hand, 
    INV_WAREHOUSE_SK as warehouse_sk,
    current_timestamp as loaded_at
from
    {{source('tpcds','inventory')}}