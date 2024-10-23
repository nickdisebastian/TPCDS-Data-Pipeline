{% snapshot customer_snapshot %}

    {{
        config(
            target_schema = 'intermediate',
            strategy='timestamp',
            unique_key='customer_sk',
            updated_at='_AIRBYTE_EXTRACTED_AT'
        )
    }}

select * from {{ref('stg_tpcds__customer')}}

{% endsnapshot %}