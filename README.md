# REGULAR CRIME DATA LOAD TASK
# By Katerina Papi
# Wednesday 15th May 2024

# Task Overview

The task was to set up a process that provides data analysts with automated, monthly loads of street-level crime data from data.police.uk into a database that shows the crime count by type for every street in the UK, for the purposes of risk modelling. 


# Important Characteristics of the data set

1. Location Data: Each crime record contains longitude and latitude coordinates along with a location description, the area in which the crime falls within, and the LSOA code and name. It was important to recognise the relevance of each column related to location, and to assess how they would benefit the data analysts. 
2. Identifier: Each crime incident is associated with an LSOA (Lower Layer Super Output Area) code, which can serve as a primary identifier for data within each geographical area, allowing for spatial analysis.
3. Crime Type: As there were several different crime types that needed to be counted, after transforming the data it was important to group the data together by street, as opposed to crime type


# What I Achieved

I successfully established an ELT pipeline, in which I can load street-level crime data from data.police.uk, into an AWS S3 bucket and integrated it with Snowflake, in which the data can then be transformed to provide the data analysts with the relevant information for further analysis. 

# Methodology

1. Manual Data Retrieval: Selected 'all forces' for March 2024 to download and saved the '2024-03' folder locally
2. Cloud Storage Set Up: I created an AWS S3 bucket and uploaded the dataset to allow for cloud-based data storage
3. IAM Role Configuration: I configured an IAM role in AWS to establish secure access between Snowflake and the S3 bucket
4. Storage Integration: I then set up storage integration on Snowflake to allow interaction between Snowflake and the S3 bucket
5. Table and File Formatting: I defined the table and file format to accommodate the raw crime data
6. External Stage Creation: I then created an external stage in Snowflake to hold the csv files before loading into the database
7. Loading Data to Table: Once I had listed the contents of the external stage to check the process had been successful so far, I used the 'COPY INTO' command to load the data from the stage to the table, whilst using 'ON_ERROR = ABORT_STATEMENT' so that if there were any errors on loading there wouldn't be any partial loading and would send us the errors 
8. Transformations: Finally I transformed the data to calculate a column for the 'crime count', and chose to group the data by street, as per the task requirements.

# Automatically Retrieving Data

The requirements of this task stated that this pipeline should be automated monthly. Unfortunately, I wasn't able to achieve this within this timeline, although through research I established how it could be possible. 

# Attempts with Automation Tools:
1. AWS: I began experimenting with AWS Glue and discovered 'crawlers' which are designed to simplify the process of organising data for use with AWS services
2. Azure: I attempted to extract the data automatically by learning about Azure Data Factory processes and how to create a pipeline on Azure, which has a web function that uses a 'url' and 'GET' command to retrieve data from a website. It's also possible for Snowflake to use Blob Storage, instead of an S3 bucket, as an external stage.  I ran the pipeline I craeted without errors, however it still wasn't collecting the data from the url. 
3. API: After more research, I found that using an API may be the appropriate method to extracting this data automatically. The issues I had when attempting this were that the parameters it required were the latitude and longitude, which produces a spcific location, which wasn't relevant to the task as I needed to be able to access every street in the UK. 
I found that web scraping was potentially necessary for this task, which can be done through using tools like Azure Functions with scripting languages (Python) and libraries like requests and BeautifulSoup  
I also noticed that the API was in JSON so it would be my preference to convert to CSV
4. Snowpipe: I tried to use Snowpipe to pull data from the S3 bucket, but had some issues with connecting it, so instead I connected Snowflake with the S3. Ideally I would've liked to use Snowpipe since this automatically pulls the data in and performs transformations as soon as new files are avilable in the S3 


# Reflections- Issues & Considerations:

1. At first I as unsure whether to use Azure or AWS. I decided on AWS since I was more familiar with it
2. If the pipeline was automated, it would be important to be aware that if the website structure changes, the pipeline would need to be updated
3. I wasn't sure what an LSOA code and name were at the start so thought it wouldn't be relevant to the task requirements. However, after researching I decided it would be helpful for analysts to group together and analyse insurance claims or incidents based on specific geographic areas, and help understand localised risk factors
4. In terms of transformations, I considered adding in a ID column to group street locations together, and concatenating the LSOA code with the LSOA name, but decided to leave the separate because the code on its own can be used to identify specific areas in analysis
5. I also considered any privacy concerns but thought that since it's public information this wouldn't be an issue. I also found a section on their website where they address privacy and anonymisation concerns, showing me that they have already made any necessary adjustments: "There was consultation between the Information Commissioner's Office and Data Protection specialists in the Home Office in the run up to releasing this data, working within their guidance to create an anonymisation process which adequately minimises privacy risks whilst still meeting our transparency goals and being useful to the public." 

# GitHub

All of my work has been pushed to a repository 




