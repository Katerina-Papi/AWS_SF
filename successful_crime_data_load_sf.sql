-- use role accountadmin to execute admin tasks
USE ROLE accountadmin;

-- create external stage integration for s3 storage
-- allows snowflake to interact with s3
CREATE OR REPLACE STORAGE INTEGRATION aws_sf_data
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = S3
ENABLED = TRUE
STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::xxxxxxxxxxxx:role/crime-role-1'
STORAGE_ALLOWED_LOCATIONS = ('s3://crime-data-load');

-- describe the details of stage to check 
DESC INTEGRATION aws_sf_data;

-- work within correct database
USE DATABASE crime_data_load;

-- define file format to hold csv files
CREATE OR REPLACE FILE FORMAT my_csv_format
TYPE = 'CSV'
FIELD_DELIMITER = ','
DATE_FORMAT = "YYYY-MM"
RECORD_DELIMITER = '\n'
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
SKIP_HEADER = 1;

--  create table to hold raw data from external source
CREATE OR REPLACE TABLE raw_data_load(
    Crime_ID VARCHAR(255),
    Month DATE,
    Reported_by VARCHAR(255),
    Falls_within VARCHAR(255),
    Longitude NUMBER,
    Latitude NUMBER,
    Location VARCHAR(255),
    LSOA_code VARCHAR(255),
    LSOA_name VARCHAR(255),
    Crime_type VARCHAR(255),
    Last_outcome_category VARCHAR(255),
    Context VARCHAR(255)
);

-- create external stage that uses integration and file format previously made 
-- (virtual location that represents specific external storage i.e. s3)
CREATE OR REPLACE STAGE external_stage
STORAGE_INTEGRATION = aws_sf_data
URL = 's3://crime-data-load/2024-03/'
FILE_FORMAT = my_csv_format;

-- after running, list files available in external stage for loading
LIST @external_stage;

-- copy data from external stage into raw data load table
COPY INTO raw_data_load FROM @external_stage ON_ERROR = ABORT_STATEMENT;