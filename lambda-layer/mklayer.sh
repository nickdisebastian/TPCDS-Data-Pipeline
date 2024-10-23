# establish environment
mkdir -p lambda_layers/python/lib/python3.12/site-packages
python3 -m venv venv
source venv/bin/activate

# install the dependencies in the desired folder
pip3 install  -r requirements.txt -t lambda_layers/python/lib/python3.12/site-packages/.

# Zip the lambda_layers folder
cd lambda_layers
zip -r snowflake_lambda_layer.zip *

# publish layer
aws lambda publish-layer-version \
    --layer-name fl-snowflake-lambda-layer \
    --compatible-runtimes python3.12 \
    --zip-file fileb://snowflake_lambda_layer.zip