select
    _AIRBYTE_EXTRACTED_AT,
    IB_LOWER_BOUND as lower_bound,
    IB_UPPER_BOUND as upper_bound,
    IB_INCOME_BAND_SK as income_band_sk
from
    {{source('tpcds','income_band')}}