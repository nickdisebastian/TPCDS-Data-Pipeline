select
    _AIRBYTE_EXTRACTED_AT,
    CAL_DT,
    WK_NUM,
    YR_NUM,
    MNTH_NUM,
    D_DATE_ID as date_id,
    D_DATE_SK as date_sk,
    YR_WK_NUM,
    YR_MNTH_NUM,
    DAY_OF_WK_NUM,
    DAY_OF_WK_DESC
from
    {{source('tpcds','date_dim')}}