import os
import boto3
import toml
import snowflake.connector as sf
from dotenv import load_dotenv

def lambda_handler(event, context):

    # File paths
    app_config = toml.load('config.toml')
    url = app_config['S3']['S3_url']
    destination_folder = app_config['local_paths']['destination_folder']
    file_name = app_config['local_paths']['file_name']
    local_file_path = app_config['local_paths']['local_file_path']
    
    # Snowflake connection parameters
    account = app_config['Snowflake']['account']
    warehouse = app_config['Snowflake']['warehouse']
    database = app_config['Snowflake']['database']
    schema = app_config['Snowflake']['schema']
    table = app_config['Snowflake']['table']
    role= app_config['Snowflake']['role']
    stage_name = app_config['Snowflake']['stage_name']

    #Load Snowflake password credentials from .env file
    load_dotenv()
    user=os.getenv('user')
    password=os.getenv('password')
    
    # Load AWS Access Key and Secret from .env file
    aws_access_key_id = os.getenv('aws_access_key_id')
    aws_secret_access_key = os.getenv('aws_secret_access_key')
    
    # Download the file from the S3 bucket
    client = boto3.client(
        's3',    
        aws_access_key_id=aws_access_key_id,
        aws_secret_access_key=aws_secret_access_key
        )

    client.download_file(Bucket='de-materials-tpcds', Key=file_name, Filename=local_file_path, ExtraArgs={'RequestPayer': 'requester'})

    print('file downloaded')
        
    # Establish Snowflake connection
    conn = sf.connect(user = user, password = password, \
                 account = account, warehouse=warehouse, \
                  database=database,  schema=schema,  role=role)

    print('connected to snowflake')

    cursor = conn.cursor()
    
    # use schema
    use_schema = f"use schema {schema};"
    cursor.execute(use_schema)
    
    # create CSV format
    create_csv_format = f"CREATE or REPLACE FILE FORMAT COMMA_CSV TYPE ='CSV' FIELD_DELIMITER = ',';"
    cursor.execute(create_csv_format)    
    
    #create stage
    create_stage_query = f"CREATE OR REPLACE STAGE {stage_name} FILE_FORMAT =COMMA_CSV"
    cursor.execute(create_stage_query)

    # Copy file from local to stage
    copy_into_stage_query = f"PUT 'file://{local_file_path}' @{stage_name}"
    cursor.execute(copy_into_stage_query)
    
    # truncate table
    truncate_table = f"truncate table {schema}.{table};"  
    cursor.execute(truncate_table)    

    # Load data from stage into a table (example)
    copy_into_query = f"COPY INTO {schema}.{table} FROM @{stage_name}/{file_name} FILE_FORMAT =COMMA_CSV ON_ERROR = 'CONTINUE';"  
    cursor.execute(copy_into_query)

    print("File uploaded to Snowflake successfully.")

    return {
        'statusCode': 200,
        'body': 'File downloaded and uploaded to Snowflake successfully.'
    }