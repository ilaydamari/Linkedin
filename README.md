# Project Preview
Linkedin Project

This is one of 5 projects in a volunteer program called "JunDatyst" - a project to help junior data analysts gain professional experience and produce data analysis project.

This is a unique project that analyzes the profession of Data Analyst in Israel on Linkedin's platform.
All the data in this project is real information from profiles of Data Analysts in Israel.
The dataset represents 679 real Data Analyst profiles in Israel witch scraped with c++ scraping tool during Jun 2022 - May 2022.

The project consists :
1) Project Overview & Explanation - PDF
2) Raw Data - CSV
3) Business Questions - Excel 
4) Conclusions & Visualization - Power BI Dashboard + PDF
5) SQL queries - divided to Views (Snowflake Datawarehouse) - at the bottom of this document.


## Project Levels

|Level |Explnation|
|------|----------|
|Data Scraping|Download C++ Program for Scraping and specify the profiles fron Data Analysts in Israel, Upload the data to Snowflake Data Warehouse and create Schemes and Views|
|Data Cleaning|Using SQL functions we adjust the data and the table to a better way we can use and query the data for our business questions|
|Classify Business Questions|Asking and finding right questions to better understand the needs and the proffestion of Data Analyst in Israel|
|Data Analysis|Query the data using SQL functions in Snowflake platform for finding conclusions|
|Visualization|Connecting our Data Warehouse on Snowflake to Power BI and creating dashboard and graphs for presenting our conclusions|



## SQL Queries
Note : Becuase of the raw data from the scraping tool, most of the questions contain more Views build one on another to clean and preper the data.
       Each View seperated with doted line (------)
       
### 1) Bussiness Question - Degree vs. Course, Which Path will Increase your Chances to become data analyst?
```sql
view 1

create or replace view LINK.PUBLIC.EDUCATION(
	PROFILELINK,
	FIRSTNAME,
	LASTNAME,
	CURRENTJOB,
	JOBYEARS,
	DURATION,
	EDUCATION,
	DEGREE,
	CERTIFICATIONS,
	COURSES,
	AWARDS
) as
select PROFILELINK,FIRSTNAME,LASTNAME, CURRENTJOB,JOBYEARS, DURATION,EDUCATION,DEGREE, CERTIFICATIONS,
COURSES, AWARDS
from 
(

select *
from "LINK"."PUBLIC"."LINKEDIN"
where currentjob LIKE ANY ('%Analyst%','%analyst%','%ANALYST%')
 
union

select *
from "LINK"."PUBLIC"."LINKEDIN"
where currentjob2 LIKE ANY ('%Analyst%','%analyst%','%ANALYST%')

union

select *
from "LINK"."PUBLIC"."LINKEDIN"
where currentjob3 LIKE ANY ('%Analyst%','%analyst%','%ANALYST%')


union

select *
from "LINK"."PUBLIC"."LINKEDIN"
where LASTJOB LIKE ANY ('%Analyst%','%analyst%','%ANALYST%')

union	

select *
from "LINK"."PUBLIC"."LINKEDIN"
where PASTJOB2 LIKE ANY ('%Analyst%','%analyst%','%ANALYST%')

union
	
select *
from "LINK"."PUBLIC"."LINKEDIN"
where PASTJOB3 LIKE ANY ('%Analyst%','%analyst%','%ANALYST%')

)
;

-----------------------------------------------------------------------------------------
view 2

create or replace view LINK.PUBLIC.EDUCATION_PARTS(
	EDUCATION,
	PART1_EDUC,
	PART1_SCHOOL,
	PART1_SESSION,
	PART2_EDUC,
	PART2_SCHOOL,
	PART2_SESSION,
	PART3_EDUC,
	PART3_SCHOOL,
	PART3_SESSION,
	PART4_EDUC,
	PART4_SCHOOL,
	PART4_SESSION,
	PART5_EDUC,
	PART5_SCHOOL,
	PART5_SESSION
) as select qq.education,

replace(replace(split_part((part_1), 'School:{',1),'[ Degree:{ ',''),' }', '') part1_educ,

split_part(split_part((part_1), 'School:{',2),'} ','1')  as part1_school,

split_part(split_part((part_1), 'Session:{',2),'} ','1')  as part1_session,

replace(replace(split_part((part_2), 'School:{',1),' Degree:{ ',''),' }', '') part2_educ,

split_part(split_part((part_2), 'School:{',2),'} ','1')  as part2_school,
split_part(split_part((part_2), 'Session:{',2),'} ','1')  as part2_session,

replace(replace(split_part((part_3), 'School:{',1),'Degree:{ ',''),' }', '') part3_educ,

split_part(split_part((part_3), 'School:{',2),'} ','1')  as part3_school,
split_part(split_part((part_3), 'Session:{',2),'} ','1')  as part3_session,

replace(replace(split_part((part_4), 'School:{',1),'Degree:{ ',''),' }', '') part4_educ,

split_part(split_part((part_4), 'School:{',2),'} ','1')  as part4_school,
split_part(split_part((part_4), 'Session:{',2),'} ','1')  as part4_session,

replace(replace(split_part((part_5), 'School:{',1),'Degree:{ ',''),' }', '') part5_educ,

split_part(split_part((part_5), 'School:{',2),'} ','1')  as part5_school,
split_part(split_part((part_5), 'Session:{',2),'} ','1')  as part5_session


from ( select PROFILELINK,EDUCATION,  to_variant(EDUCATION), 
 split_part((EDUCATION), '][',1)::variant part_1,
split_part((EDUCATION), '][',2) part_2,
split_part((EDUCATION), '][',3) part_3,
split_part((EDUCATION), '][',4) part_4,
split_part((EDUCATION), '][',5) part_5
 
 
from "LINK"."PUBLIC"."EDUCATION"
) qq

;

-----------------------------------------------------------------------------------------
view 3

create or replace view LINK.PUBLIC.EDUCATION_MAX(
	PROFILELINK,
	EDUCATION,
	PART1_EDUC,
	PART1_SCHOOL,
	MAX_SESSION
) as
select distinct PROFILELINK, a.EDUCATION	, PART1_EDUC,PART1_SCHOOL	,max(PART1_SESSION) as max_session	 
from

(select EDUCATION	, PART1_EDUC,PART1_SCHOOL	,PART1_SESSION	 	from "LINK"."PUBLIC"."EDUCATION_PARTS"
union
select EDUCATION	, PART2_EDUC,PART2_SCHOOL	,PART2_SESSION	 	from "LINK"."PUBLIC"."EDUCATION_PARTS"
union
select EDUCATION	, PART3_EDUC,PART3_SCHOOL	,PART3_SESSION	 	from "LINK"."PUBLIC"."EDUCATION_PARTS"
union
select EDUCATION	, PART4_EDUC,PART4_SCHOOL	,PART4_SESSION	 	from "LINK"."PUBLIC"."EDUCATION_PARTS"
union

select EDUCATION	, PART5_EDUC,PART5_SCHOOL	,PART5_SESSION	 	from "LINK"."PUBLIC"."EDUCATION_PARTS") a
join  "LINK"."PUBLIC"."linkedin" b
on a.EDUCATION=b.EDUCATION

where not (PART1_EDUC is null and PART1_SCHOOL is null and PART1_SESSION is null)
and not (PART1_EDUC = '' and PART1_SCHOOL  = '' and PART1_SESSION  = '')

group by 1,2,3,4

order by 1;

-----------------------------------------------------------------------------------------
view 4

create or replace view LINK.PUBLIC.EDUCATION_MAX2(
	PROFILELINK,
	EDUCATION,
	PART1_EDUC,
	PART1_SCHOOL,
	MAX_SESSION
) as
select distinct PROFILELINK, a.EDUCATION	, PART1_EDUC,PART1_SCHOOL	,max(PART1_SESSION) as max_session	 
from

(select EDUCATION	, PART1_EDUC,PART1_SCHOOL	,PART1_SESSION	 	from "LINK"."PUBLIC"."EDUCATION_PARTS"
union
select EDUCATION	, PART2_EDUC,PART2_SCHOOL	,PART2_SESSION	 	from "LINK"."PUBLIC"."EDUCATION_PARTS"
union
select EDUCATION	, PART3_EDUC,PART3_SCHOOL	,PART3_SESSION	 	from "LINK"."PUBLIC"."EDUCATION_PARTS"
union
select EDUCATION	, PART4_EDUC,PART4_SCHOOL	,PART4_SESSION	 	from "LINK"."PUBLIC"."EDUCATION_PARTS"
union

select EDUCATION	, PART5_EDUC,PART5_SCHOOL	,PART5_SESSION	 	from "LINK"."PUBLIC"."EDUCATION_PARTS") a
join  "LINK"."PUBLIC"."linkedin" b
on a.EDUCATION=b.EDUCATION

where not (PART1_EDUC is null and PART1_SCHOOL is null and PART1_SESSION is null)
and not (PART1_EDUC = '' and PART1_SCHOOL  = '' and PART1_SESSION  = '')

group by 1,2,3,4

order by 1;

-----------------------------------------------------------------------------------------
view 5

create or replace view LINK.PUBLIC."People_Only_Course"(
	PROFILELINK,
	EDUCATION,
	PART1_EDUC,
	PART1_SCHOOL,
	PEOPLE
) as
select distinct PROFILELINK::string, EDUCATION, PART1_EDUC, PART1_SCHOOL, count (PROFILELINK) as People
from "LINK"."PUBLIC"."EDUCATION_MAX2"
where PROFILELINK not in ( 
  
  
select distinct PROFILELINK
from "LINK"."PUBLIC"."EDUCATION_MAX"
where PART1_SCHOOL not like '%Certific%'
                              and EDUCATION not like 'null'
                              and PART1_SCHOOL not like '%Elevation Academy%'
                              and PART1_SCHOOL not like '%High School%'
                              and PART1_SCHOOL not like '%itc%'
                              and PART1_SCHOOL not like '%Challenge%'
                              and PART1_SCHOOL not like '%Bosmat%'
                              and PART1_SCHOOL not like '%codes%'
                              and PART1_SCHOOL not like '%Practicum%'
                              and PART1_SCHOOL not like '%NAYA%'
                              and PART1_SCHOOL not like '%Experis%'
                              and PART1_SCHOOL not like '%Literature%'
                              and PART1_SCHOOL not like '%John Bryce%'
                              and PART1_SCHOOL not like '%Literature%'
                              and PART1_SCHOOL not like '%edX%'
                              and PART1_SCHOOL not like '%Udemy%'
                              and PART1_SCHOOL not like '%high%'
                              and PART1_SCHOOL not like '%Mahat%'
                              and PART1_SCHOOL not like '%Hakfar%'
                              and PART1_SCHOOL not like '%Goethe%'
                              and PART1_SCHOOL not like ''
                              and PART1_SCHOOL not like '%Primrose%'
                              and PART1_SCHOOL not like '%Expe%'
                              and PART1_SCHOOL not like '%Mamram%'
                              and PART1_SCHOOL not like '%Mansa%'
                              and PART1_SCHOOL not like '%UERJ%'
                              and PART1_SCHOOL not like '%SVCollege%'
                              and PART1_SCHOOL not like '%Ebin%'
                              and PART1_SCHOOL not like '%.jpg%'
                              and PART1_SCHOOL not like '%pdf%'
                              and PART1_SCHOOL not like '%YDATA%'
                              and PART1_SCHOOL not like '%Ginsburg%'
                              and PART1_SCHOOL not like '%Course%'
                              and PART1_SCHOOL not like '%Thinkful%'
                              and PART1_SCHOOL not like '%Kamatech%'
                              and PART1_SCHOOL not like '%datappl%'
                              and PART1_SCHOOL not like '%COURSE %'
                              and PART1_SCHOOL not like '%EXPERT%'
                              and PART1_SCHOOL not like '%Elevation%'
                              and PART1_SCHOOL not like '%Ulpanat%'
                              and PART1_SCHOOL not like '%Sport Panel%'
                              and PART1_SCHOOL not like '%8200%'
                              and PART1_SCHOOL not like '%Experis%'
                              and PART1_SCHOOL not like '%Ehad%'
                              and PART1_SCHOOL not like '%Mekif%'
                              and PART1_SCHOOL not like '%Kfar%'
                              and PART1_SCHOOL not like '%IDF%'
                              and PART1_SCHOOL not like '%Project%'
                              and PART1_SCHOOL not like '%Tel Mond%'
                              and PART1_SCHOOL not like '%ltd%'
                              and PART1_SCHOOL not like '%Program%'
                              and PART1_SCHOOL not like '%UCL%'
                              and PART1_SCHOOL not like '%devtodev%'
                              and PART1_SCHOOL not like '%New-Media%'
                              and PART1_SCHOOL not like '%Cisco%'
                              and PART1_SCHOOL not like '%Give & Tech%'
                              and PART1_SCHOOL not like '%IDF%'
                              and PART1_SCHOOL not like '%yeshiva%'
                              and PART1_SCHOOL not like '%Military%'
                              and PART1_SCHOOL not like '%Mishlav%'
                              and PART1_SCHOOL not like '%Datappl%'
                              and PART1_SCHOOL not like '%rogozin%'
                              and PART1_SCHOOL not like '%BSMCH%'
                              and PART1_SCHOOL not like '%Prodware%'
                              and PART1_SCHOOL not like '%Ein Gedi%'
                              and PART1_SCHOOL not like '%Coursera%'
                              and PART1_SCHOOL not like '%See-Security%'
                              and PART1_SCHOOL not like '%Nofi%'
                              and PART1_SCHOOL not like '%Magshimim%'
                              and PART1_SCHOOL not like '%Project%'
                              and PART1_SCHOOL not like '%Jolt%'
                              and PART1_SCHOOL not like '%Ness%'
                              and PART1_SCHOOL not like '%Mosenson%'
                              and PART1_SCHOOL not like '%compTIA%'
                              and PART1_SCHOOL not like '%SQLBI%'
                              and PART1_SCHOOL not like '%certificate%'
                              and PART1_SCHOOL not like '%Evolution%'
                              and PART1_SCHOOL not like '%Google%'
                              and PART1_SCHOOL not like '%100%'

                           )
group by PROFILELINK::string, EDUCATION, PART1_EDUC, PART1_SCHOOL           
having PART1_SCHOOL not like '%univ%'
and PART1_SCHOOL not like '%Univ%'
and PART1_SCHOOL not like '%academic%'
and PART1_SCHOOL not like '%Academic%'
and EDUCATION not like '%null%';
```

### 2) Bussiness Question - In What Areas do Most Analysts Work at?
```sql
View 1
create or replace view LINK.PUBLIC.LOCATIONS(
	PROFILELINK,
	LOCATION,
	CURRENTJOB,
	LOCATIONS
) as select profilelink, Location, currentjob, count(profilelink) as locations
from "LINK"."PUBLIC"."LINKEDIN"
where currentjob not like '%null%'
and Location not like '%null%'
and (currentjob like '%Analyst%' 
or currentjob like '%analyst%'
or currentjob like '%data%'
or currentjob like '%Data%')
group by profilelink, Location, currentjob
 
union

select profilelink, CurrentLocation2, currentjob2, count(profilelink) as locations
from "LINK"."PUBLIC"."LINKEDIN"
where currentjob2 not like '%null%'
and CurrentLocation2 not like '%null%'
and (currentjob2 like '%Analyst%' 
or currentjob2 like '%analyst%'
or currentjob2 like '%data%'
or currentjob2 like '%Data%')
group by profilelink, CurrentLocation2, currentjob2

union

select profilelink, CurrentLocation3, currentjob3, count(profilelink) as locations
from "LINK"."PUBLIC"."LINKEDIN"
where currentjob3 not like '%null%'
and CurrentLocation3 not like '%null%'
and (currentjob3 like '%Analyst%' 
or currentjob3 like '%analyst%'
or currentjob3 like '%data%'
or currentjob3 like '%Data%')
group by profilelink, CurrentLocation3, currentjob3

union

select profilelink, LASTJOBLOCATION1, LASTJOB, count(profilelink) as locations
from "LINK"."PUBLIC"."LINKEDIN"
where LASTJOB not like '%null%'
and LASTJOBLOCATION1 not like '%null%'
and (LASTJOB like '%Analyst%' 
or LASTJOB like '%analyst%'
or LASTJOB like '%data%'
or LASTJOB like '%Data%')
group by profilelink, LASTJOBLOCATION1, LASTJOB

union	

select profilelink, PASTLOCATION2, PASTJOB2, count(profilelink) as locations
from "LINK"."PUBLIC"."LINKEDIN"
where PASTJOB2 not like '%null%'
and PASTLOCATION2 not like '%null%'
and (PASTJOB2 like '%Analyst%' 
or PASTJOB2 like '%analyst%'
or PASTJOB2 like '%data%'
or PASTJOB2 like '%Data%')
group by profilelink, PASTLOCATION2, PASTJOB2

union
	
select profilelink, PASTLOCATION3, PASTJOB3, count(profilelink) as locations
from "LINK"."PUBLIC"."LINKEDIN"
where PASTJOB3 not like '%null%'
and PASTLOCATION3 not like '%null%'
and (PASTJOB3 like '%Analyst%' 
or PASTJOB3 like '%analyst%'
or PASTJOB3 like '%data%'
or PASTJOB3 like '%Data%')
group by profilelink, PASTLOCATION3, PASTJOB3

-----------------------------------------------------------------------------------------
View 2

create or replace view LINK.PUBLIC."LOCATIONS_parts"(
	PROFILELINK,
	LOCATION,
	PART_1,
	PART_2,
	PART_3,
	PART_4,
	CURRENTJOB,
	LOCATIONS
) as select profilelink, LOCATION,
split_part((LOCATION), ';',1):: variant part_1,
split_part((LOCATION), ';',2):: variant part_2,
split_part((LOCATION), ';',3):: variant part_3,
split_part((LOCATION), ';',4):: variant part_4,
CURRENTJOB,
LOCATIONS

from 
"LINK"."PUBLIC"."LOCATIONS"
;

-----------------------------------------------------------------------------------------
View 3

create or replace view LINK.PUBLIC."LOCATIONS_Total"(
	PROFILELINK,
	CITY,
	LOCATION_NUM
) as 
select profilelink, replace (PART_1, '"', '') as City, sum(LOCATIONS) as Location_Num
from "LINK"."PUBLIC"."LOCATIONS_parts"
group by 1,2;

-----------------------------------------------------------------------------------------
View 4

create or replace view LINK.PUBLIC."Region_City"(
	PROFILELINK,
	CITY,
	REGION,
	NUMBER
) as
select profilelink, City,
     case when city like any ('%Tel Aviv%', '%Herzliya%', '%Ramat Gan%', '%Petah Tikva%', '%Givatayim%', '%Bnei Brak%', '%Rishon%', '%Lod%', '%ananna%', 'Holon','%Reẖovot%', '%Haדharon%',
                          '%Rosh Ha%', 'Kiryat Ono', '%anana%', '%Yavne%', '%Nes Ziyona%', '%Hasharon%', '%Rehovot%', '%Ramla%', '%Ramat Gan%', 'Kadima', 'Shefayim',  'Ness Ziona',  'Airport City', 'Kfar Sava') then 'Central'
     when city like any ('%Beersheba%','%Glil-Yam%', '%KIRYAT GAT%', '%Kiryat Gat%') then 'South'
     when city like any ('%Haifa%', '%Netanya%', '%Yokne%', '%Ayin%', 'Yakum') then 'North'
     when city like any ('%Jerusalem%', '%kadima%',  '%airport%', '%Modiin%') then 'East'
     when city like any ('Unknown', '%Israel%', '%israel%', '%Isreal%', '%Israël%', 'Remote', '%Bank Leumi%', '%Hachshara%', 'Central', 'Centre', '%South%', '%south%', '%North%', '%north%') then 'Unknown'
     else 'World'
     end Region,
     sum(LOCATION_NUM) as Number
from 
(
select case when city like any ('%Tel Aviv%', '%tel aviv%', 'Tel-Aviv') then 'Tel Aviv'
            when city like any ('%Ramat Ga%', '%ramat gan%') then 'Ramat Gan'
            when city like any ('%Herz%', '%Hertz%', '%herz%') then 'Herzliya'
            when city like any ('%Jerus%', '%jerus%') then 'Jerusalem'
            when city like any ('%Petaẖ%', '%Tiqwa%', '%petaẖ%', '%Petah%') then 'Petah Tikva'
            when city like any ('%Ataym%', '%atayim%', '%Giva%', '%giva%') then 'Givatayim'
            when city like any ('%haifa%', '%Haifa%', '%Hayfa%') then 'Haifa'
            when city like any ('%Qiryat%', '%KIRYAT GAT%', '%qiryat%', '%Kiryat Gat%', '%kiryat gat%') then 'Kiryat Gat'
            when city like any ('%rehovot%', '%Rehovot%','%Reẖovo%', '%reẖovo%' ) then 'Rehovot'
            when city like any ('%Kefar Sava%', '%Kfar Sava%', '%kefar sava%', '%kfar sava%', '%KFAR SAVA%') then 'Kfar Sava'
            when city like any ('%ananna%', '%anana%') then 'Raananna'
            when city like any ('%bear%', '%Beer%', '%beer%', '%sheba%') then 'Beersheba'
            when city like any ('%Modiin%', '%Maccabim%', '%modiin%', '%maccabim%') then 'Modiin Maccabim Reut'
            when city like any ('%kadima%', '%Kadima%', '%Tzoran%', '%tzoran%') then 'Kadima'
            when city like any ('%yakum%', '%Yakum%') then 'Yakum'
            when city like any ('%caesar%', '%Caesarea%', '%caesarea%') then 'Caesarea'
            when city like any ('%brak%', '%Bnei Brak%', '%braq%', '%bney%', '%Bene%') then 'Bnei Brak'
            when city like any ('%Raml%', '%raml%') then 'Ramla'
            when city like any ('%yokne%', '%Yokne%') then 'Yokneam'
            when city like any ('%glil-Yam%', '%Glil-Yam%') then 'Glil-Yam'
            when city like any ('%netanya%', '%Netanya%') then 'Netanya'
            when city like any ('%hasharon%', '%HaSharon%') then 'Hod Hasharon'
            when city like any ('%ramat hasharon%', '%Ramat Hasharon%', 'Hasharon') then 'Ramat Hasharon'
            when city like any ('%holon%', '%Holon%') then 'Holon'
            when city like any ('%rishon%', '%Rishon%') then 'Rishon Letzion'
            when city like any ('%ness%', '%Ziona%', '%Tziona%', 'Nes Ziyyona') then 'Ness Ziona'
            when city like any ('%shefayim%', '%Shefayim%') then 'Shefayim'
            when city like any ('%lod%', '%Lod%') then 'Lod'
            when city like any ('%Yavne%', '%yavne%') then 'Yavne'
            when city like any ('%ha‘ayin%', '%Ha‘Ayin%') then 'Rosh Ha-Ayin'
            when city like any ('%ono%', '%Ono%') then 'Kiryat Ono'
            when city like any ('%Jerus%', '%jerus%') then 'Jerusalem'
            when city like any ('%airport%') then 'Airport City'

            else city
            end City,
  
profilelink, LOCATION_NUM
  from "LINK"."PUBLIC"."LOCATIONS_Total"
)
group by 
1,2, 3
order by Number desc;
```
