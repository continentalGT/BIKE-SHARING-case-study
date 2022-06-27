use project;



#JOINING ALL MONTHS TABLE

CREATE TABLE 2021_jan_dec AS (select *
from tripdata_202101
UNION select *
from tripdata_202102
union SELECT * 
FROM tripdata_202103
UNION SELECT *
FROM tripdata_202104
UNION SELECT*
FROM tripdata_202105
UNION SELECT *
FROM tripdata_202106
UNION SELECT *
FROM tripdata_202107
UNION SELECT *
FROM tripdata_202108
UNION SELECT *
from tripdata_202109
UNION SELECT *
FROM tripdata_202110
UNION SELECT *
FROM tripdata_202111
UNION SELECT *
FROM tripdata_202112);

#checking
select *
from 2021_jan_dec;

#CHECKING DUPLICATE DATA

SELECT DISTINCT *
FROM 2021_jan_dec;


#remove redundant columns
ALTER TABLE  2021_jan_dec
DROP start_lat, drop start_lng,drop end_lat,drop end_lng;


##CHECKING FOR BLANK VALUES OF EACH COLOUMN AND CONVERTING THEM TO NULL
select ride_id
from 2021_jan_dec
where ride_id ='';

select rideable_type
from 2021_jan_dec
where rideable_type='';

SELECT started_at
from 2021_jan_dec
where started_at ='';

SELECT ended_at
from 2021_jan_dec
where ended_at ='';

SELECT start_station_name
from 2021_jan_dec
where start_station_name='';

UPDATE 2021_jan_dec
SET start_station_name=if(Start_station_name='',NULL,start_station_name);

select end_station_name
from 2021_jan_dec
where end_station_name='';

select start_station_id
from 2021_jan_dec
where start_station_id='';

select end_station_id
from 2021_jan_dec
where end_station_id = ''; 

select member_casual
from 2021_jan_dec
where member_casual='';

update 2021_jan_dec
set
end_station_name=CASE end_station_name WHEN '' THEN NULL ELSE end_station_name END,
start_station_id=CASE start_station_id WHEN '' THEN NULL ELSE start_station_id END,
end_station_id=CASE end_station_id WHEN '' THEN NULL ELSE end_station_id END;

#checking
SELECT *
FROM 2021_jan_dec;

##ADDING COLUMN
ALTER TABLE 2021_jan_dec
ADD COLUMN START_STATION VARCHAR(255);

UPDATE 2021_jan_dec
SET START_STATION=concat(START_STATION_NAME,'',START_STATION_ID);

ALTER TABLE 2021_jan_dec
ADD column END_STATION VARCHAR(255);


UPDATE 2021_jan_dec
SET END_STATION=concat(END_STATION_NAME,'',END_STATION_ID);

ALTER TABLE 2021_jan_dec
DROP START_STATION_NAME,
DROP START_STATION_ID,
DROP END_STATION_NAME,
DROP END_STATION_ID;


SELECT *
FROM 2021_jan_dec;

ALTER TABLE 2021_jan_dec
ADD COLUMN ROUTE VARCHAR(255),
ADD COLUMN WEEKDAY VARCHAR(20),
ADD COLUMN preferred_hr INT(64),
ADD COLUMN TRIP_DURATION INT(64);

UPDATE 2021_jan_dec
SET ROUTE=concat(START_STATION,' TO ',END_STATION );

##FINDING PREFFERED WEEKDAY
update 2021_jan_dec set WEEKDAY=dayname(started_at);

#CHECKING
SELECT *
FROM 2021_jan_dec;

##FINDING PREFERRED HOUR
update 2021_jan_dec
set preferred_hr=hour(started_at);


#Finding duration of trip_duration
update 2021_jan_dec
set trip_duration=timestampdiff(Second,started_at,ended_at);


#CHECKING
SELECT *
FROM 2021_jan_dec;

#ANALYSIS

##propotion of casual and annual members

create table propotion (select member_casual,count(member_casual)
from 2021_jan_dec
group by member_casual);

select *
from propotion;

##POPULAR BIKE AMONG CASUAL MEMBERS
CREATE TABLE BIKE(
SELECT RIDEABLE_TYPE,count(RIDEABLE_TYPE) AS MOST_PREFERRED_BIKE
FROM casual_members
GROUP BY RIDEABLE_TYPE
ORDER BY MOST_PREFERRED_BIKE DESC);

SELECT *
FROM BIKE;


##analysis on only casual members

create table casual_members(select *
from 2021_jan_dec
where member_casual='casual');

select *
from casual_members;

##Casual members who rides more than 24 hours
create table casual_24(select *
from 2021_jan_dec
where member_casual='casual' and trip_duration > 86400
order by trip_duration desc);

select *
from casual_24;

##monthly analysis

select *
from 2021_jan_dec;

alter table 2021_jan_dec
add column Month varchar(16);

update 2021_jan_dec
set Month=monthname(started_at);

CREATE TABLE MONTH (SELECT MONTH,count(MONTH)
FROM casual_members
group by MONTH);

SELECT *
FROM MONTH;

##weekly analysis

CREATE TABLE WEEKDAYS (select WEEKDAY,COUNT(WEEKDAY) as Numbers
FROM casual_members
Group by WEEKDAY
order by Numbers DESC );

SELECT *
FROM WEEKDAYS;

##HOUR ANALYSIS

create table Hr(SELECT preferred_hr,count(preferred_hr)
FROM casual_members
GROUP BY preferred_hr
order by preferred_hr);

select *
from hr;

select *
from casual_members;

##TOP 20 POPULAR START STATION
create table pop_start_station(
select start_station,count(start_station) as popular_start_station
from casual_members
where start_station != 'NULL' 
group by start_station
ORDER BY popular_start_station DESC
limit 20);

select*
from pop_start_station;


##POPULAR END STATION
create table pop_end_station(
select end_station,count(end_station) as popular_end_station
from casual_members
where end_station !='null'
group by end_station 
ORDER BY  popular_end_station DESC
LIMIT 20);

select * from pop_end_station;


##POPULAR ROUTE
create table pop_route(
select route,count(route) as popular_route
from casual_members
where route != 'null'
group by route
order by popular_route DESC
LIMIT 20);

select *
from pop_route;


#VISUALIZATION

SELECT *
FROM BIKE;

select *
from casual_24;

select * 
FROM casual_members;

select *
from hr;

select *
from month;

select*
from pop_end_station;

select *
from pop_route;

select * from pop_start_station;

select *
from propotion;

select *
from weekdays;


