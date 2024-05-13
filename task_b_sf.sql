-- use role accountadmin to execute admin tasks
use role accountadmin;

-- create external stage integration for s3 storage
-- allows snowflake to interact with s3
create or replace storage integration aws_sf_data
type = external_stage
storage_provider = s3
enabled = true
storage_aws_role_arn = 'arn:aws:iam::xxxxxxxxxxxx:role/crime-role-1'
storage_allowed_locations = ('s3://crime-data-load');

-- describe the details of stage to check 
desc integration aws_sf_data;

--work within correct db
use database crime_data_load;

-- define file format to hold csv files
create or replace file format my_csv_format
type = 'csv'
field_delimiter = ','
date_format = "YYYY-MM"
record_delimiter = '\n'
field_optionally_enclosed_by = '"'
skip_header = 1;

-- create table to hold raw data from external source
create or replace table raw_data_load(
Crime_ID varchar(255),
Month date,
Reported_by varchar(255),
Falls_within varchar(255),
Longitude number,
Latitude number,
Location varchar(255),
LSOA_code varchar(255),
LSOA_name varchar(255),
Crime_type varchar(255),
Last_outcome_category varchar(255),
Context varchar(255)
);

-- create external stage that uses integration and file format previously made 
-- (virtual location that represents specific external storage i.e. s3)
create or replace stage external_stage
storage_integration = aws_sf_data   -- defines where to look for data
url = 's3://crime-data-load/2024-03/'
file_format = my_csv_format;
-- attempting connection to s3 with aws credentials:
-- credentials = (
-- aws_key_id = 'AKIAZQ3DTNSPXPHXDMFH'
-- aws_secret_key = '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'
--aws_role = 'arn:aws:iam::654654532767:user/crime-data-iam-user'

-- after running, list files available in external stage for loading
list @external_stage;

-- copy data from external stage into raw data load table
-- abort the operation if any errors occur
copy into raw_data_load from @external_stage on_error = abort_statement;

-- creating snowpipe for continuous data ingestion 
create or replace pipe crime_snowpipe
auto_ingest = true
as
copy into raw_data_load
from @external_stage
file_format = (format_name = my_csv_format);

-- creating role (used to manage access control and permissions)
create role my_role;

-- grant usage permission on external stage to role
grant usage on stage external_stage to role my_role;

-- grant monitor permission on pipe to role
-- giving role permission to monitor the pipe
grant monitor on pipe crime_snowpipe to role my_role;

-- display all records from raw data load table
select * from raw_data_load;