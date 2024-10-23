select 
    _AIRBYTE_EXTRACTED_AT,
    HD_DEMO_SK as demo_sk,
    HD_DEP_COUNT as dep_count,
    HD_BUY_POTENTIAL as buy_potential,
    HD_VEHICLE_COUNT as vehicle_count,
    HD_INCOME_BAND_SK as income_band_sk
from
    {{source('tpcds','household_demographics')}}