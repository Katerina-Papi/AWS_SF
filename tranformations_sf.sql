-- select * from raw_data_load;

select month, falls_within, location, LSOA_code, LSOA_name, crime_type, count(*) as crime_count
from raw_data_load
group by month, falls_within, location, LSOA_code, LSOA_name, crime_type;   -- grouped to keep streets together

-- once automated, this would be the transformation in snowpipe 