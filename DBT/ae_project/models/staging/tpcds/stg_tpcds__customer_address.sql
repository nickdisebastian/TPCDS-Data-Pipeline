select  
    _AIRBYTE_EXTRACTED_AT, 
    CA_ZIP as zip, 
    CA_CITY as city, 
    CA_STATE as state, 
    CA_COUNTY as county, 
    CA_COUNTRY as country, 
    CA_ADDRESS_ID as address_id, 
    CA_ADDRESS_SK as address_sk, 
    CA_GMT_OFFSET as gmt_offset, 
    CA_STREET_NAME as street_name, 
    CA_STREET_TYPE as street_type, 
    CA_SUITE_NUMBER as suite_number, 
    CA_LOCATION_TYPE as location_type, 
    CA_STREET_NUMBER as street_number
from
    {{source('tpcds','customer_address')}}