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

## The team
Team leader: Ilay Damari https://www.linkedin.com/in/ilay-damari/
Team members: Ido Kahlon https://www.linkedin.com/in/ido-kahlon/
		Ayelet Biton https://www.linkedin.com/in/ayelet-biton-8779b01b9/
		Nofar Hakmon https://www.linkedin.com/in/nofar-hakmon/



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
       Each View seperated with doted line (------)'
       
### 1) Bussiness Question - Degree vs. Course, Which path will Increase your chances to become Data Analyst?
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
from ""LINK"".""PUBLIC"".""LINKEDIN""
where currentjob LIKE ANY ('%Analyst%','%analyst%','%ANALYST%')
 
union

select *
from ""LINK"".""PUBLIC"".""LINKEDIN""
where currentjob2 LIKE ANY ('%Analyst%','%analyst%','%ANALYST%')

union

select *
from ""LINK"".""PUBLIC"".""LINKEDIN""
where currentjob3 LIKE ANY ('%Analyst%','%analyst%','%ANALYST%')


union

select *
from ""LINK"".""PUBLIC"".""LINKEDIN""
where LASTJOB LIKE ANY ('%Analyst%','%analyst%','%ANALYST%')

union        

select *
from ""LINK"".""PUBLIC"".""LINKEDIN""
where PASTJOB2 LIKE ANY ('%Analyst%','%analyst%','%ANALYST%')

union
        
select *
from ""LINK"".""PUBLIC"".""LINKEDIN""
where PASTJOB3 LIKE ANY ('%Analyst%','%analyst%','%ANALYST%')

)
;

-----------------------------------------------------------------------------------------
view 

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
 
 
from ""LINK"".""PUBLIC"".""EDUCATION""
) qq

;

-----------------------------------------------------------------------------------------
view 

create or replace view LINK.PUBLIC.EDUCATION_MAX(
        PROFILELINK,
        EDUCATION,
        PART1_EDUC,
        PART1_SCHOOL,
        MAX_SESSION
) as
select distinct PROFILELINK, a.EDUCATION        , PART1_EDUC,PART1_SCHOOL        ,max(PART1_SESSION) as max_session         
from

(select EDUCATION        , PART1_EDUC,PART1_SCHOOL        ,PART1_SESSION                 from ""LINK"".""PUBLIC"".""EDUCATION_PARTS""
union
select EDUCATION        , PART2_EDUC,PART2_SCHOOL        ,PART2_SESSION                 from ""LINK"".""PUBLIC"".""EDUCATION_PARTS""
union
select EDUCATION        , PART3_EDUC,PART3_SCHOOL        ,PART3_SESSION                 from ""LINK"".""PUBLIC"".""EDUCATION_PARTS""
union
select EDUCATION        , PART4_EDUC,PART4_SCHOOL        ,PART4_SESSION                 from ""LINK"".""PUBLIC"".""EDUCATION_PARTS""
union

select EDUCATION        , PART5_EDUC,PART5_SCHOOL        ,PART5_SESSION                 from ""LINK"".""PUBLIC"".""EDUCATION_PARTS"") a
join  ""LINK"".""PUBLIC"".""linkedin"" b
on a.EDUCATION=b.EDUCATION

where not (PART1_EDUC is null and PART1_SCHOOL is null and PART1_SESSION is null)
and not (PART1_EDUC = '' and PART1_SCHOOL  = '' and PART1_SESSION  = '')

group by 1,2,3,4

order by 1;

-----------------------------------------------------------------------------------------

view 

create or replace view LINK.PUBLIC.EDUCATION_MAX2(
        PROFILELINK,
        EDUCATION,
        PART1_EDUC,
        PART1_SCHOOL,
        MAX_SESSION
) as
select distinct PROFILELINK, a.EDUCATION        , PART1_EDUC,PART1_SCHOOL        ,max(PART1_SESSION) as max_session         
from

(select EDUCATION        , PART1_EDUC,PART1_SCHOOL        ,PART1_SESSION                 from ""LINK"".""PUBLIC"".""EDUCATION_PARTS""
union
select EDUCATION        , PART2_EDUC,PART2_SCHOOL        ,PART2_SESSION                 from ""LINK"".""PUBLIC"".""EDUCATION_PARTS""
union
select EDUCATION        , PART3_EDUC,PART3_SCHOOL        ,PART3_SESSION                 from ""LINK"".""PUBLIC"".""EDUCATION_PARTS""
union
select EDUCATION        , PART4_EDUC,PART4_SCHOOL        ,PART4_SESSION                 from ""LINK"".""PUBLIC"".""EDUCATION_PARTS""
union

select EDUCATION        , PART5_EDUC,PART5_SCHOOL        ,PART5_SESSION                 from ""LINK"".""PUBLIC"".""EDUCATION_PARTS"") a
join  ""LINK"".""PUBLIC"".""linkedin"" b
on a.EDUCATION=b.EDUCATION

where not (PART1_EDUC is null and PART1_SCHOOL is null and PART1_SESSION is null)
and not (PART1_EDUC = '' and PART1_SCHOOL  = '' and PART1_SESSION  = '')

group by 1,2,3,4

order by 1;

-----------------------------------------------------------------------------------------
view

create or replace view LINK.PUBLIC.""People_Only_Course""(
        PROFILELINK,
        EDUCATION,
        PART1_EDUC,
        PART1_SCHOOL,
        PEOPLE
) as
select distinct PROFILELINK::string, EDUCATION, PART1_EDUC, PART1_SCHOOL, count (PROFILELINK) as People
from ""LINK"".""PUBLIC"".""EDUCATION_MAX2""
where PROFILELINK not in ( 
  
  
select distinct PROFILELINK
from ""LINK"".""PUBLIC"".""EDUCATION_MAX""
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
and EDUCATION not like '%null%';"
```

### 2) Bussiness Question - Wich Degree is the most common between Data Analysts?
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
from ""LINK"".""PUBLIC"".""LINKEDIN""
where currentjob LIKE ANY ('%Analyst%','%analyst%','%ANALYST%')
 
union

select *
from ""LINK"".""PUBLIC"".""LINKEDIN""
where currentjob2 LIKE ANY ('%Analyst%','%analyst%','%ANALYST%')

union

select *
from ""LINK"".""PUBLIC"".""LINKEDIN""
where currentjob3 LIKE ANY ('%Analyst%','%analyst%','%ANALYST%')


union

select *
from ""LINK"".""PUBLIC"".""LINKEDIN""
where LASTJOB LIKE ANY ('%Analyst%','%analyst%','%ANALYST%')

union        

select *
from ""LINK"".""PUBLIC"".""LINKEDIN""
where PASTJOB2 LIKE ANY ('%Analyst%','%analyst%','%ANALYST%')

union
        
select *
from ""LINK"".""PUBLIC"".""LINKEDIN""
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
 
 
from ""LINK"".""PUBLIC"".""EDUCATION""
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
select distinct PROFILELINK, a.EDUCATION        , PART1_EDUC,PART1_SCHOOL        ,max(PART1_SESSION) as max_session         
from

(select EDUCATION        , PART1_EDUC,PART1_SCHOOL        ,PART1_SESSION                 from ""LINK"".""PUBLIC"".""EDUCATION_PARTS""
union
select EDUCATION        , PART2_EDUC,PART2_SCHOOL        ,PART2_SESSION                 from ""LINK"".""PUBLIC"".""EDUCATION_PARTS""
union
select EDUCATION        , PART3_EDUC,PART3_SCHOOL        ,PART3_SESSION                 from ""LINK"".""PUBLIC"".""EDUCATION_PARTS""
union
select EDUCATION        , PART4_EDUC,PART4_SCHOOL        ,PART4_SESSION                 from ""LINK"".""PUBLIC"".""EDUCATION_PARTS""
union

select EDUCATION        , PART5_EDUC,PART5_SCHOOL        ,PART5_SESSION                 from ""LINK"".""PUBLIC"".""EDUCATION_PARTS"") a
join  ""LINK"".""PUBLIC"".""linkedin"" b
on a.EDUCATION=b.EDUCATION

where not (PART1_EDUC is null and PART1_SCHOOL is null and PART1_SESSION is null)
and not (PART1_EDUC = '' and PART1_SCHOOL  = '' and PART1_SESSION  = '')

group by 1,2,3,4

order by 1;

-----------------------------------------------------------------------------------------
view 4

create or replace view LINK.PUBLIC.""Sum_of_Education_Parts""(
        PROFILELINK,
        EDUCATION,
        PEOPLE
) as
select profilelink,
   case when PART1_EDUC like '%Economics%' or PART1_EDUC like '%economics%' or PART1_EDUC like '%Economy%' or PART1_EDUC like '%Finance%'  or PART1_EDUC like '%economic%' or PART1_EDUC like '%Financial%'
   or PART1_EDUC like '%finance%'  
     then 'Economics'
     when PART1_EDUC like '%Industrial Management%' or PART1_EDUC like '%Industrial Engineering and Management%' or PART1_EDUC like '%Industrial Engineering%'
     or PART1_EDUC like '%industrial engineering%' or PART1_EDUC like '%הנדסה%' or  PART1_EDUC like '%Industrial engineering%' or PART1_EDUC like '%Industrial and Management%'
     or PART1_EDUC like '%Practical engineering%'

     then 'Industrial Engineering and Management'
     when PART1_EDUC like '%Computer Science%' or PART1_EDUC like '%Computer%'  then 'Computer Science'
     when PART1_EDUC like '%Information%' then 'Information Systems'
     when PART1_EDUC like '%Law%'  then 'Law'
     when PART1_EDUC like '%Statist%' or PART1_EDUC like '%statis%' then 'Statistics'
     when PART1_EDUC like '%Analyst%' or PART1_EDUC like 'Data Science' or PART1_EDUC like 'Data analyst' 
     or PART1_EDUC like 'BI Developer' or PART1_EDUC like 'Python' or PART1_EDUC like 'Java' 
     or PART1_EDUC like '%analyst%' or PART1_EDUC like '%Excel%' or PART1_EDUC like '%Bootcamp%' 
     or PART1_EDUC like 'BI Development' 
     or PART1_EDUC like '%course%'
     or PART1_EDUC like '%Java%'
     or PART1_EDUC like '%Development%'
     or PART1_EDUC like '%course%'
     or PART1_EDUC like '%Python%'
     or PART1_EDUC like '%Tableau%'
     or PART1_EDUC like '%program%'
     or PART1_EDUC like '%analyst%'
     then 'Course'
     when PART1_EDUC like '%Behavioral%'  then 'Behavioral Sciences'
     when PART1_EDUC like 'physics'  then 'Physics'
     when PART1_EDUC like '%Marketing%'  then 'Marketing'
     when PART1_EDUC like '%Media%'  then 'Communication and Media'
     when PART1_EDUC like '%bussiness%' or PART1_EDUC like '%Business%' then 'Business Administration'
     when PART1_EDUC like '%Medical%' or PART1_EDUC like '%Health%'  then 'Medical'
     when PART1_EDUC like '%Philosophy%' or PART1_EDUC like '%psychology%' then 'Philosophy'
     when PART1_EDUC like '% Computer Systems Analysis%'  then ' Computer Systems Analysis'
     when PART1_EDUC like '%}%' or PART1_EDUC like '' or PART1_EDUC like 'null' then 'null'
     when PART1_EDUC like '%Psychology%'  then 'Psychology'
     when PART1_EDUC like '%High School%'  then 'High School'
     when PART1_EDUC like '%Geography%'  then 'Geography'
     when PART1_EDUC like '%Neuroscience%'  then 'Neuroscience'
     when PART1_EDUC like '%Math%' or PART1_EDUC like '%mathematics%' or PART1_EDUC like '%math%'  then 'Mathematics'
     when PART1_EDUC like '%Political%'  then 'Political Science'
     when PART1_EDUC like '%Accounting%'  then 'Accounting'
     when PART1_EDUC like '%AI%'  then 'AI'
     when PART1_EDUC like '%Government%'  then 'Government Science'
     when PART1_EDUC like '%Environmental%'  then 'Environmental'
     when PART1_EDUC like '%Biology%'  then 'Biology'
     when PART1_EDUC like '%Genetic%'  then 'Genetic'
     when PART1_EDUC like '%East-Asian%' or PART1_EDUC like '%Asian%' or PART1_EDUC like '%Chinese%'  then 'East-Asian'
     when PART1_EDUC like '%Criminology%' or PART1_EDUC like '%Criminal%'  then 'Criminology'
     when PART1_EDUC like '%Arabic%'  then 'Arabic'
     when PART1_EDUC like '%Neuroscience%'  then 'Neuroscience'
     when PART1_EDUC like '%software engineering%'  or PART1_EDUC like '%software%' or PART1_EDUC like '%Software%' then 'Software Engineering'
     when PART1_EDUC like '%Soil%'  then 'Soil Science'
     when PART1_EDUC like '%English%'  or PART1_EDUC like '%Languages%'  then 'English'
     when PART1_EDUC like '%Physical%'   or PART1_EDUC like '%Physics%' then 'Physical'
     when PART1_EDUC like '%Chemistry%'  then 'Chemistry'
     when PART1_EDUC like '%Cognitive%'  then 'Cognitive'
     when PART1_EDUC like '%General%'  then 'General'
     when PART1_EDUC like '%Art%'  then 'Arts'
     when PART1_EDUC like '%General%'  then 'General'
     when PART1_EDUC like '%Chemical%'  then 'Chemical'
     when PART1_EDUC like '%Bioinformatics%'  then 'Bioinformatics'
     when PART1_EDUC like '%Biotechnology%'  then 'Biotechnology'

else PART1_EDUC
     end as education,
     
     count (distinct profilelink) as People
     
from ""LINK"".""PUBLIC"".""EDUCATION_MAX""
group by profilelink,
   case when PART1_EDUC like '%Economics%' or PART1_EDUC like '%economics%' or PART1_EDUC like '%Economy%' or PART1_EDUC like '%Finance%'  or PART1_EDUC like '%economic%' or PART1_EDUC like '%Financial%'
   or PART1_EDUC like '%finance%'  
     then 'Economics'
     when PART1_EDUC like '%Industrial Management%' or PART1_EDUC like '%Industrial Engineering and Management%' or PART1_EDUC like '%Industrial Engineering%'
     or PART1_EDUC like '%industrial engineering%' or PART1_EDUC like '%הנדסה%' or  PART1_EDUC like '%Industrial engineering%' or PART1_EDUC like '%Industrial and Management%'
     or PART1_EDUC like '%Practical engineering%'

     then 'Industrial Engineering and Management'
     when PART1_EDUC like '%Computer Science%' or PART1_EDUC like '%Computer%'  then 'Computer Science'
     when PART1_EDUC like '%Information%' then 'Information Systems'
     when PART1_EDUC like '%Law%'  then 'Law'
     when PART1_EDUC like '%Statist%' or PART1_EDUC like '%statis%' then 'Statistics'
     when PART1_EDUC like '%Analyst%' or PART1_EDUC like 'Data Science' or PART1_EDUC like 'Data analyst' 
     or PART1_EDUC like 'BI Developer' or PART1_EDUC like 'Python' or PART1_EDUC like 'Java' 
     or PART1_EDUC like '%analyst%' or PART1_EDUC like '%Excel%' or PART1_EDUC like '%Bootcamp%' 
     or PART1_EDUC like 'BI Development' 
     or PART1_EDUC like '%course%'
     or PART1_EDUC like '%Java%'
     or PART1_EDUC like '%Development%'
     or PART1_EDUC like '%course%'
     or PART1_EDUC like '%Python%'
     or PART1_EDUC like '%Tableau%'
     or PART1_EDUC like '%program%'
     or PART1_EDUC like '%analyst%'
     then 'Course'
     when PART1_EDUC like '%Behavioral%'  then 'Behavioral Sciences'
     when PART1_EDUC like 'physics'  then 'Physics'
     when PART1_EDUC like '%Marketing%'  then 'Marketing'
     when PART1_EDUC like '%Media%'  then 'Communication and Media'
     when PART1_EDUC like '%bussiness%' or PART1_EDUC like '%Business%' then 'Business Administration'
     when PART1_EDUC like '%Medical%' or PART1_EDUC like '%Health%'  then 'Medical'
     when PART1_EDUC like '%Philosophy%' or PART1_EDUC like '%psychology%' then 'Philosophy'
     when PART1_EDUC like '% Computer Systems Analysis%'  then ' Computer Systems Analysis'
     when PART1_EDUC like '%}%' or PART1_EDUC like '' or PART1_EDUC like 'null' then 'null'
     when PART1_EDUC like '%Psychology%'  then 'Psychology'
     when PART1_EDUC like '%High School%'  then 'High School'
     when PART1_EDUC like '%Geography%'  then 'Geography'
     when PART1_EDUC like '%Neuroscience%'  then 'Neuroscience'
     when PART1_EDUC like '%Math%' or PART1_EDUC like '%mathematics%' or PART1_EDUC like '%math%'  then 'Mathematics'
     when PART1_EDUC like '%Political%'  then 'Political Science'
     when PART1_EDUC like '%Accounting%'  then 'Accounting'
     when PART1_EDUC like '%AI%'  then 'AI'
     when PART1_EDUC like '%Government%'  then 'Government Science'
     when PART1_EDUC like '%Environmental%'  then 'Environmental'
     when PART1_EDUC like '%Biology%'  then 'Biology'
     when PART1_EDUC like '%Genetic%'  then 'Genetic'
     when PART1_EDUC like '%East-Asian%' or PART1_EDUC like '%Asian%' or PART1_EDUC like '%Chinese%'  then 'East-Asian'
     when PART1_EDUC like '%Criminology%' or PART1_EDUC like '%Criminal%'  then 'Criminology'
     when PART1_EDUC like '%Arabic%'  then 'Arabic'
     when PART1_EDUC like '%Neuroscience%'  then 'Neuroscience'
     when PART1_EDUC like '%software engineering%'  or PART1_EDUC like '%software%' or PART1_EDUC like '%Software%' then 'Software Engineering'
     when PART1_EDUC like '%Soil%'  then 'Soil Science'
     when PART1_EDUC like '%English%'  or PART1_EDUC like '%Languages%'  then 'English'
     when PART1_EDUC like '%Physical%'   or PART1_EDUC like '%Physics%' then 'Physical'
     when PART1_EDUC like '%Chemistry%'  then 'Chemistry'
     when PART1_EDUC like '%Cognitive%'  then 'Cognitive'
     when PART1_EDUC like '%General%'  then 'General'
     when PART1_EDUC like '%Art%'  then 'Arts'
     when PART1_EDUC like '%General%'  then 'General'
     when PART1_EDUC like '%Chemical%'  then 'Chemical'
     when PART1_EDUC like '%Bioinformatics%'  then 'Bioinformatics'
     when PART1_EDUC like '%Biotechnology%'  then 'Biotechnology'

     else PART1_EDUC
     end 
     order by People desc
;

-----------------------------------------------------------------------------------------
view 5

create or replace view LINK.PUBLIC.SUM_OF_EDUCATION(
        PROFILELINK,
        EDUCATION,
        EDUCATION_TYPE,
        PEOPLE
) as select
PROFILELINK ,
EDUCATION,
case when education like 'Course' then 'Course'
     when education like any ( 
'Economics'
,'Industrial Engineering and Management'
,'Computer Science'
,'Information Systems'
,'Law'
,'Statistics'
,'Behavioral Sciences'
,'Physics'
,'Marketing'
,'Communication and Media'
,'Business Administration'
,'Medical'
,'Philosophy'
,' Computer Systems Analysis'
,'Psychology'
,'High School'
,'Geography'
,'Neuroscience'
,'Mathematics'
,'Political Science'
,'Accounting'
,'AI'
,'Government Science'
,'Environmental'
,'Biology'
,'Genetic'
,'East-Asian'
,'Criminology'
, 'Arabic'
,'Neuroscience'
,'Software Engineering'
,'Soil Science'
,'English'
,'Physical'
,'Chemistry'
,'Cognitive'
,'General'
,'Arts'
,'General'
,'Chemical'
,'Bioinformatics'
,'Biotechnology'
     ) then 'Degree'
     else 'Unknown'
     end as Education_Type,
PEOPLE
from ""LINK"".""PUBLIC"".""Sum_of_Education_Parts"";"
```

### 3) Bussiness Question - In what areas do most Analysts work at?
```sql
View 1
create or replace view LINK.PUBLIC.LOCATIONS(
        PROFILELINK,
        LOCATION,
        CURRENTJOB,
        LOCATIONS
) as select profilelink, Location, currentjob, count(profilelink) as locations
from ""LINK"".""PUBLIC"".""LINKEDIN""
where currentjob not like '%null%'
and Location not like '%null%'
and (currentjob like '%Analyst%' 
or currentjob like '%analyst%'
or currentjob like '%data%'
or currentjob like '%Data%')
group by profilelink, Location, currentjob
 
union

select profilelink, CurrentLocation2, currentjob2, count(profilelink) as locations
from ""LINK"".""PUBLIC"".""LINKEDIN""
where currentjob2 not like '%null%'
and CurrentLocation2 not like '%null%'
and (currentjob2 like '%Analyst%' 
or currentjob2 like '%analyst%'
or currentjob2 like '%data%'
or currentjob2 like '%Data%')
group by profilelink, CurrentLocation2, currentjob2

union

select profilelink, CurrentLocation3, currentjob3, count(profilelink) as locations
from ""LINK"".""PUBLIC"".""LINKEDIN""
where currentjob3 not like '%null%'
and CurrentLocation3 not like '%null%'
and (currentjob3 like '%Analyst%' 
or currentjob3 like '%analyst%'
or currentjob3 like '%data%'
or currentjob3 like '%Data%')
group by profilelink, CurrentLocation3, currentjob3

union

select profilelink, LASTJOBLOCATION1, LASTJOB, count(profilelink) as locations
from ""LINK"".""PUBLIC"".""LINKEDIN""
where LASTJOB not like '%null%'
and LASTJOBLOCATION1 not like '%null%'
and (LASTJOB like '%Analyst%' 
or LASTJOB like '%analyst%'
or LASTJOB like '%data%'
or LASTJOB like '%Data%')
group by profilelink, LASTJOBLOCATION1, LASTJOB

union        

select profilelink, PASTLOCATION2, PASTJOB2, count(profilelink) as locations
from ""LINK"".""PUBLIC"".""LINKEDIN""
where PASTJOB2 not like '%null%'
and PASTLOCATION2 not like '%null%'
and (PASTJOB2 like '%Analyst%' 
or PASTJOB2 like '%analyst%'
or PASTJOB2 like '%data%'
or PASTJOB2 like '%Data%')
group by profilelink, PASTLOCATION2, PASTJOB2

union
        
select profilelink, PASTLOCATION3, PASTJOB3, count(profilelink) as locations
from ""LINK"".""PUBLIC"".""LINKEDIN""
where PASTJOB3 not like '%null%'
and PASTLOCATION3 not like '%null%'
and (PASTJOB3 like '%Analyst%' 
or PASTJOB3 like '%analyst%'
or PASTJOB3 like '%data%'
or PASTJOB3 like '%Data%')
group by profilelink, PASTLOCATION3, PASTJOB3

-----------------------------------------------------------------------------------------
View 2

create or replace view LINK.PUBLIC.""LOCATIONS_parts""(
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
""LINK"".""PUBLIC"".""LOCATIONS""
;

-----------------------------------------------------------------------------------------
View 3

create or replace view LINK.PUBLIC.""LOCATIONS_Total""(
        PROFILELINK,
        CITY,
        LOCATION_NUM
) as 
select profilelink, replace (PART_1, '""', '') as City, sum(LOCATIONS) as Location_Num
from ""LINK"".""PUBLIC"".""LOCATIONS_parts""
group by 1,2;

-----------------------------------------------------------------------------------------
View 4

create or replace view LINK.PUBLIC.""Region_City""(
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
  from ""LINK"".""PUBLIC"".""LOCATIONS_Total""
)
group by 
1,2, 3
order by Number desc;"
```
### 4) Bussiness Question - What is the Percentage of Analysts that Work Part Time vs Full Time?
```sql
view 1 

create or replace view LINK.PUBLIC.""Job_Types""(
        PROFILELINK,
        COMPANY1,
        POSITION_SCOPE,
        CURRENTCOMPANY2,
        CURRENTCOMPANY3,
        LASTJOB_COMPANY,
        PASTCOMPANY2,
        PASTCOMPANY3,
        CURRENTJOB,
        CURRENTJOB2,
        CURRENTJOB3,
        LASTJOB,
        PASTJOB2,
        PASTJOB3
) as
select PROFILELINK,
COMPANY1,
POSITION_SCOPE,
CURRENTCOMPANY2,
CURRENTCOMPANY3,
lastjob_company,
pastcompany2,
pastcompany3,
CURRENTJOB,
CURRENTJOB2,
CURRENTJOB3,
LASTJOB,
pastjob2,
pastjob3
from ""LINK"".""PUBLIC"".""LINKEDIN""
WHERE LASTJOB_COMPANY not like '%Part-time%'
or   LASTJOB_COMPANY  not like '%PART-TIME%'
or   LASTJOB_COMPANY  not like'%part-time%'
or   LASTJOB_COMPANY  not like '%Part-Time%';

-----------------------------------------------------------------------------------------
view 2

create or replace view LINK.PUBLIC.JPB_TYPES2(
        PROFILELINK1,
        POSITION,
        CURRENTJOB,
        PROFILELINK2,
        POSITION2,
        CURRENTJOB2,
        PROFILELINK3,
        POSITION3,
        CURRENTJOB3,
        PROFILELINK4,
        LAST_POSITION,
        LASTJOB,
        PROFILELINK5,
        LAST_POSITION2,
        PASTJOB2,
        PROFILELINK6,
        LAST_POSITION3,
        PASTJOB3
) as 

select a.PROFILELINK as ""a.PROFILELINK"",
POSITION,
CURRENTJOB,
b.PROFILELINK as ""b.PROFILELINK"",
POSITION2,
CURRENTJOB2,
c.PROFILELINK as ""c.PROFILELINK"",
POSITION3,
CURRENTJOB3,
d.PROFILELINK as ""d.PROFILELINK"",
LAST_POSITION,
LASTJOB,
e.PROFILELINK as ""e.PROFILELINK"",
LAST_POSITION2,
PASTJOB2,
f.PROFILELINK as ""f.PROFILELINK"",
LAST_POSITION3,
PASTJOB3

from
(select PROFILELINK, CURRENTJOB, COMPANY1, POSITION_SCOPE, replace (POSITION_SCOPE, POSITION_SCOPE, 'Full Time') as POSITION

from ""LINK"".""PUBLIC"".""Job_Types""
WHERE COMPANY1 not like '%null%'
and   COMPANY1 not like '%Null%'
and   COMPANY1 not like '%NULL%'
and   COMPANY1 not like '%NULL%'
and   POSITION_SCOPE not like '%Part-time%'
) a

full join

(select PROFILELINK, CURRENTJOB2, CURRENTCOMPANY2, replace (CURRENTCOMPANY2, CURRENTCOMPANY2, 'Full Time') as POSITION2
from ""LINK"".""PUBLIC"".""Job_Types""
WHERE CURRENTJOB2         not like '%null%'
and   CURRENTJOB2         not like '%Null%'
and   CURRENTJOB2         not like '%NULL%'
and   CURRENTJOB2         not like '%NULL%'
and   CURRENTCOMPANY2 not like '%Part-time%' ) b

on a.PROFILELINK=b.PROFILELINK

full join


(select PROFILELINK, CURRENTJOB3, CURRENTCOMPANY3, replace (CURRENTCOMPANY3, CURRENTCOMPANY3, 'Full Time') as POSITION3
from ""LINK"".""PUBLIC"".""Job_Types""
WHERE CURRENTJOB3         not like '%null%'
and   CURRENTJOB3         not like '%Null%'
and   CURRENTJOB3         not like '%NULL%'
and   CURRENTJOB3         not like '%NULL%'
and   CURRENTCOMPANY3 not like '%Part-time%') c

on a.PROFILELINK=c.PROFILELINK

full join

(select PROFILELINK, LASTJOB, LASTJOB_COMPANY        , replace (LASTJOB_COMPANY        , LASTJOB_COMPANY        , 'Full Time') as last_POSITION
from ""LINK"".""PUBLIC"".""Job_Types""
WHERE LASTJOB         not like '%null%'
and   LASTJOB         not like '%Null%'
and   LASTJOB         not like '%NULL%'
and   LASTJOB         not like '%NULL%'
and   LASTJOB_COMPANY         not like '%Part-time%') d

on a.PROFILELINK=d.PROFILELINK

full join 

(select PROFILELINK, PASTJOB2, PASTCOMPANY2                , replace (PASTCOMPANY2                , PASTCOMPANY2                , 'Full Time') as last_POSITION2
from ""LINK"".""PUBLIC"".""Job_Types""
WHERE PASTJOB2         not like '%null%'
and   PASTJOB2         not like '%Null%'
and   PASTJOB2         not like '%NULL%'
and   PASTJOB2         not like '%NULL%'
and   PASTCOMPANY2                 not like '%Part-time%') e

on a.PROFILELINK=e.PROFILELINK

full join 

(select PROFILELINK, PASTJOB3, PASTCOMPANY3                , replace (PASTCOMPANY3                , PASTCOMPANY3                , 'Full Time') as last_POSITION3
from ""LINK"".""PUBLIC"".""Job_Types""
WHERE PASTJOB3         not like '%null%'
and   PASTJOB3         not like '%Null%'
and   PASTJOB3         not like '%NULL%'
and   PASTJOB3         not like '%NULL%'
and   PASTCOMPANY3                 not like '%Part-time%') f

on a.PROFILELINK=f.PROFILELINK

;

-----------------------------------------------------------------------------------------
view 3

create or replace view LINK.PUBLIC.ALL_POSITIONS_NUMBER(
        FULL_TIME1,
        FULL_TIME2,
        FULL_TIME3,
        FULL_TIME4,
        FULL_TIME5,
        FULL_TIME6
) as select 
count(a.POSITION) as Full_Time1,
count(b.POSITION2) as Full_Time2,
count(c.POSITION3) as Full_Time3,
count(d.LAST_POSITION        ) as Full_Time4,
count(e.LAST_POSITION2) as Full_Time5,
count(f.LAST_POSITION3) as Full_Time6
from 
(select *
from ""LINK"".""PUBLIC"".""JPB_TYPES2""
WHERE 
CURRENTJOB LIKE  any ('%Analyst%','%analyst','%ANALYST%')
) a

full join

(select *
from ""LINK"".""PUBLIC"".""JPB_TYPES2""
WHERE 
CURRENTJOB2 LIKE  any ('%Analyst%','%analyst','%ANALYST%')
) b
on a.PROFILELINK1=b.PROFILELINK2
full join

(select *
from ""LINK"".""PUBLIC"".""JPB_TYPES2""
WHERE  CURRENTJOB3        LIKE  any ('%Analyst%','%analyst','%ANALYST%')
) c
on a.PROFILELINK1=c.PROFILELINK3

full join

(select *
from ""LINK"".""PUBLIC"".""JPB_TYPES2""
WHERE 
 LASTJOB LIKE  any ('%Analyst%','%analyst','%ANALYST%')
) d
on a.PROFILELINK1=d.PROFILELINK4

full join

(select *
from ""LINK"".""PUBLIC"".""JPB_TYPES2""
WHERE 
 PASTJOB2 LIKE  any ('%Analyst%','%analyst','%ANALYST%')
) e
on a.PROFILELINK1=e.PROFILELINK5

full join

(select *
from ""LINK"".""PUBLIC"".""JPB_TYPES2""
WHERE 
 PASTJOB3 LIKE  any ('%Analyst%','%analyst','%ANALYST%')
) f

on a.PROFILELINK1=f.PROFILELINK6


-----------------------------------------------------------------------------------------
view 4

create or replace view LINK.PUBLIC.""Full_Time_Analyst_Total""(
        TOTAL
) as
select sum (
Full_Time1 + Full_Time2 + Full_Time3 + Full_Time4 + Full_Time5 + Full_Time6
) as Total
from
""LINK"".""PUBLIC"".""ALL_POSITIONS_NUMBER"";

-----------------------------------------------------------------------------------------
view 5

create or replace view LINK.PUBLIC.""Part_Time_Analyst_Total""(
        TOTAL
) as
select count(*) as Total
from (
select profilelink, position_scope,currentjob
from  ""LINK"".""PUBLIC"".""linkedin""
where  position_scope  like '%Part-time%' and CURRENTJOB LIKE ANY ('%Analyst%','%analyst%','%ANALYST%')
union
  
select profilelink,CURRENTCOMPANY2
,currentjob2
from  ""LINK"".""PUBLIC"".""linkedin""
where  CURRENTCOMPANY2
  like '%Part-time%' and CURRENTJOB2 LIKE ANY ('%Analyst%','%analyst%','%ANALYST%')
union
  
select profilelink,CURRENTCOMPANY3
,currentjob3
from  ""LINK"".""PUBLIC"".""linkedin""
where  CURRENTCOMPANY3
  like '%Part-time%' and CURRENTJOB3 LIKE ANY ('%Analyst%','%analyst%','%ANALYST%')
union
  
select profilelink,lastjob,lastjob_company
from ""LINK"".""PUBLIC"".""linkedin""
where lastjob_company like '%Part-time%' and lastjob like any ('%Analyst%','%analyst','%ANALYST%')
union 
select profilelink,pastjob2,pastcompany2
from ""LINK"".""PUBLIC"".""linkedin""
where pastcompany2 like '%Part-time%' and pastjob2 like any ('%Analyst%','%analyst','%ANALYST%')
union
select profilelink,pastjob3,pastcompany3
from ""LINK"".""PUBLIC"".""linkedin""
where pastcompany3 like '%Part-time%' and pastjob3 like any ('%Analyst%','%analyst','%ANALYST%')
)
;

-----------------------------------------------------------------------------------------
View 6

create or replace view LINK.PUBLIC.""Part&Full_Time_Analyst_Total""(
        JOB_TYPE,
        TOTAL
) as




select case when Total = (select TOTAL from ""LINK"".""PUBLIC"".""Part_Time_Analyst_Total"") then 'Part Time'
            when Total = (select TOTAL from ""LINK"".""PUBLIC"".""Full_Time_Analyst_Total"") then 'Full Time'
            end as Job_Type,
            Total
from 
(
select Total
from 
""LINK"".""PUBLIC"".""Part_Time_Analyst_Total"" 
union
select Total
from
""LINK"".""PUBLIC"".""Full_Time_Analyst_Total"" 
  );"
```
### 5) Bussiness Question - How Long it Will Take to be Senior Analyst/DS/DE
```sql
view 1

create or replace view LINK.PUBLIC.DURATION_NEW(
        PROFILELINK,
        FIRSTNAME,
        LASTNAME,
        TAGLINETITLE,
        CURRENTJOB,
        COMPANY1,
        POSITION_SCOPE,
        JOBYEARS,
        JOBDATE,
        MONTH_NAME,
        DURATION,
        LOCATION,
        CURRENTJOB2,
        CURRENTCOMPANY2,
        CURRENTJOBYEARS2,
        CURRENTJOBDATE2,
        MONTH_NAME2,
        CURRENTDURATION2,
        CURRENTLOCATION2,
        CURRENTJOB3,
        CURRENTCOMPANY3,
        CURRENTJOBYEARS3,
        CURRENTJOBDATE3,
        MONTH_NAME3,
        CURRENTDURATION3,
        CURRENTLOCATION3,
        LASTJOB,
        LASTJOB_COMPANY,
        LASTJOBYEARS1_BEGIN,
        LASTJOBDATE1_BEGIN,
        LASTMONTH_NAME1_BEGIN,
        LASTJOBYEARS1_FINISH,
        LASTJOBDATE1_FINISH,
        LASTMONTH_NAME1_FINISH,
        LASTJOBDURATION1,
        LASTJOBLOCATION1,
        PASTJOB2,
        PASTCOMPANY2,
        PASTJOBYEARS2_BEGIN,
        PASTJOBDATE2_BEGIN,
        PASTJOBMONTH_NAME2_BEGIN,
        PASTJOBYEARS2_FINISH,
        PASTJOBDATE2_FINISH,
        PASTJOBMONTH_NAME2_FINISH,
        PASTDURATION2,
        PASTLOCATION2,
        PASTJOB3,
        PASTCOMPANY3,
        PASTJOBYEARS3_BEGIN,
        PASTJOBDATE3_BEGIN,
        PASTJOBMONTH_NAME3_BEGIN,
        PASTJOBYEARS3_FINISH,
        PASTJOBDATE3_FINISH,
        PASTJOBMONTH_NAME3_FINISH,
        PASTDURATION3,
        PASTLOCATION3,
        CURRENTDATE
) as SELECT    PROFILELINK,
        FIRSTNAME,
        LASTNAME,
        TAGLINETITLE,
        CURRENTJOB,
        COMPANY1,
        POSITION_SCOPE,
        REPLACE(JOBYEARS,'- Present',''),
    CONCAT (substr(JOBYEARS,5, 4 ),'-',left(JOBYEARS,3),'-','01'),
    left(JOBYEARS,3),
        DURATION,
        LOCATION,
        CURRENTJOB2,
        CURRENTCOMPANY2,
        REPLACE(CURRENTJOBYEARS2,'- Present',''),
    CONCAT (substr(CURRENTJOBYEARS2,5, 4 ),'-',left(CURRENTJOBYEARS2,3),'-','01'),
    left(CURRENTJOBYEARS2,3),
        CURRENTDURATION2,
        CURRENTLOCATION2,
        CURRENTJOB3,
        CURRENTCOMPANY3,
        REPLACE(CURRENTJOBYEARS3,'- Present',''),
    CONCAT (substr(CURRENTJOBYEARS3,5, 4 ),'-',left(CURRENTJOBYEARS3,3),'-','01'),
    left(CURRENTJOBYEARS3,3),
        CURRENTDURATION3,
        CURRENTLOCATION3,
        LASTJOB,
        LASTJOB_COMPANY,
        REPLACE(LASTJOBYEARS1_BEGIN,'- Present',''),
    CONCAT (substr(LASTJOBYEARS1_BEGIN,5, 4 ),'-',left(LASTJOBYEARS1_BEGIN,3),'-','01'),
    left(LASTJOBYEARS1_BEGIN,3),
        REPLACE(TRIM(LASTJOBYEARS1_FINISH),'- Present',''),
    CONCAT (substr(TRIM(LASTJOBYEARS1_FINISH),5, 4 ),'-',left(TRIM(LASTJOBYEARS1_FINISH),3),'-','01'),
    left(TRIM(LASTJOBYEARS1_FINISH),3),
        LASTJOBDURATION1,
        LASTJOBLOCATION1,
        PASTJOB2,
        PASTCOMPANY2,
        REPLACE(PASTJOBYEARS2_BEGIN,'- Present',''),
    CONCAT (substr(PASTJOBYEARS2_BEGIN,5, 4 ),'-',left(PASTJOBYEARS2_BEGIN,3),'-','01'),
    left(PASTJOBYEARS2_BEGIN,3),
        TRIM(PASTJOBYEARS2_FINISH),
    CONCAT (substr(TRIM(PASTJOBYEARS2_FINISH),5, 4 ),'-',left(TRIM(PASTJOBYEARS2_FINISH),3),'-','01'),
    left(TRIM(PASTJOBYEARS2_FINISH),3),
        PASTDURATION2,
        PASTLOCATION2,
        PASTJOB3,
        PASTCOMPANY3,
        REPLACE(PASTJOBYEARS3_BEGIN,'-Present',''),
    CONCAT (substr(PASTJOBYEARS3_BEGIN,5, 4 ),'-',left(PASTJOBYEARS3_BEGIN,3),'-','01'),
    left(PASTJOBYEARS3_BEGIN,3),
        TRIM(PASTJOBYEARS3_FINISH),
    CONCAT (substr(TRIM(PASTJOBYEARS3_FINISH),5, 4 ),'-',left(TRIM(PASTJOBYEARS3_FINISH),3),'-','01'),
    left(TRIM(PASTJOBYEARS3_FINISH),3),
        PASTDURATION3,
        PASTLOCATION3,
        current_date()
FROM ""LINK"".""PUBLIC"".""LINKEDIN1"";

-----------------------------------------------------------------------------------------
view 2

create or replace view LINK.PUBLIC.DURATION_NEW5(
        PROFILELINK,
        CURRENTJOB,
        ROUND_JOBDATE1,
        CURRENTJOB2,
        ROUND_CURRENTJOBDATE2,
        CURRENTJOB3,
        ROUND_CURRENTJOBDATE3,
        LASTJOB,
        ROUND_LASTJOBDATE1_FINISH,
        PASTJOB2,
        ROUND_PASTJOBDATE2_FINISH,
        PASTJOB3,
        ROUND_PASTJOBDATE3_FINISH
) as 
select PROFILELINK,
CURRENTJOB,
ROUND_JOBDATE1,
CURRENTJOB2,
ROUND_CURRENTJOBDATE2,
CURRENTJOB3,
ROUND_CURRENTJOBDATE3,
LASTJOB,
ROUND_LASTJOBDATE1_FINISH,
PASTJOB2,
ROUND_PASTJOBDATE2_FINISH,
PASTJOB3,
ROUND_PASTJOBDATE3_FINISH
from 
(
SELECT
NEW4.PROFILELINK,NEW4.CURRENTJOB,ROUND(div0((CURRENT_DATE()-NEW4.JOBDATE1::DATE),365),1) as ROUND_JOBDATE1,NEW4.CURRENTJOB2,
ROUND(div0((CURRENT_DATE()-NEW4.CURRENTJOBDATE2::DATE),365),1) as ROUND_CURRENTJOBDATE2,
NEW4.CURRENTJOB3,ROUND(div0((CURRENT_DATE()-NEW4.CURRENTJOBDATE3::DATE),365),1) as ROUND_CURRENTJOBDATE3,
NEW4.LASTJOB,
ROUND(div0((NEW4.LASTJOBDATE1_FINISH::DATE-NEW4.LASTJOBDATE1_BEGIN::DATE),365),1) as ROUND_LASTJOBDATE1_FINISH,
NEW4.PASTJOB2,
ROUND(div0((NEW4.PASTJOBDATE2_FINISH::DATE-NEW4.PASTJOBDATE2_BEGIN::DATE),365),1) as ROUND_PASTJOBDATE2_FINISH,
NEW4.PASTJOB3,
ROUND(div0((NEW4.PASTJOBDATE3_FINISH::DATE-NEW4.PASTJOBDATE3_BEGIN::DATE),365),1) as ROUND_PASTJOBDATE3_FINISH
FROM
(
SELECT 
A.PROFILELINK ,
A.CURRENTJOB,
replace (A.JOBDATE1,' - P-01-01', '1900-01-01') as JOBDATE1,
B.CURRENTJOB2,
replace (B.CURRENTJOBDATE2,' - P-01-01', '1900-01-01') as CURRENTJOBDATE2,
C.CURRENTJOB3,
C.CURRENTJOBDATE3,
D.LASTJOB,
D.LASTJOBDATE1_BEGIN,
E.LASTJOBDATE1_FINISH,
F.PASTJOB2,
F.PASTJOBDATE2_BEGIN,
G.PASTJOBDATE2_FINISH,
H.PASTJOB3,
H.PASTJOBDATE3_BEGIN,
I.PASTJOBDATE3_FINISH,
ROUND(div0((I.PASTJOBDATE3_FINISH::DATE-H.PASTJOBDATE3_BEGIN::DATE),365),1),
CURRENT_DATE()


FROM 
(SELECT PROFILELINK,CURRENTJOB,JOBDATE,
 CASE when JOBDATE in ('- P-202-01', '- P-201-01', '-190-01', '--01','- P-01-01') then CONCAT ('1900','-','01','-','01') 
  WHEN month_name like ('Jan') then CONCAT (LEFT (JOBDATE,4),'-','01','-','01')
WHEN month_name like ('Feb') then CONCAT (LEFT (JOBDATE,4),'-','02','-','01') 
WHEN month_name  like ('Mar') then CONCAT (LEFT (JOBDATE,4),'-','03','-','01')
WHEN month_name  like ('Apr') then CONCAT (LEFT (JOBDATE,4),'-','04','-','01')
WHEN month_name  like ('May') then CONCAT (LEFT (JOBDATE,4),'-','05','-','01')
WHEN month_name  like ('Jun') then CONCAT (LEFT (JOBDATE,4),'-','06','-','01')
WHEN month_name like ('Jul') then CONCAT (LEFT (JOBDATE,4),'-','07','-','01')
WHEN month_name like ('Aug') then CONCAT (LEFT (JOBDATE,4),'-','08','-','01')
WHEN month_name like ('Sep') then CONCAT (LEFT (JOBDATE,4),'-','09','-','01')
WHEN month_name like ('Oct') then CONCAT (LEFT (JOBDATE,4),'-','10','-','01')
WHEN month_name like ('Nov') then CONCAT (LEFT (JOBDATE,4),'-','11','-','01')
WHEN month_name like ('Dec') then CONCAT (LEFT (JOBDATE,4),'-','12','-','01')
else CONCAT (LEFT (JOBDATE,4),'-','01','-','01')
end AS JOBDATE1
from ""LINK"".""PUBLIC"".""DURATION_NEW"") A

JOIN 

(
SELECT PROFILELINK, CURRENTJOB2,
CASE when CURRENTJOBDATE2 in ('- P-202-01', '- P-201-01', '-190-01', '--01','- P-01-01') then CONCAT ('1900','-','01','-','01') 
WHEN MONTH_NAME2 like ('Jan') then CONCAT (LEFT (CURRENTJOBDATE2,4),'-','01','-','01')
WHEN MONTH_NAME2 like ('Feb') then CONCAT (LEFT (CURRENTJOBDATE2,4),'-','02','-','01') 
WHEN MONTH_NAME2  like ('Mar') then CONCAT (LEFT (CURRENTJOBDATE2,4),'-','03','-','01')
WHEN MONTH_NAME2  like ('Apr') then CONCAT (LEFT (CURRENTJOBDATE2,4),'-','04','-','01')
WHEN MONTH_NAME2  like ('May') then CONCAT (LEFT (CURRENTJOBDATE2,4),'-','05','-','01')
WHEN MONTH_NAME2  like ('Jun') then CONCAT (LEFT (CURRENTJOBDATE2,4),'-','06','-','01')
WHEN MONTH_NAME2 like ('Jul') then CONCAT (LEFT (CURRENTJOBDATE2,4),'-','07','-','01')
WHEN MONTH_NAME2 like ('Aug') then CONCAT (LEFT (CURRENTJOBDATE2,4),'-','08','-','01')
WHEN MONTH_NAME2 like ('Sep') then CONCAT (LEFT (CURRENTJOBDATE2,4),'-','09','-','01')
WHEN MONTH_NAME2 like ('Oct') then CONCAT (LEFT (CURRENTJOBDATE2,4),'-','10','-','01')
WHEN MONTH_NAME2 like ('Nov') then CONCAT (LEFT (CURRENTJOBDATE2,4),'-','11','-','01')
WHEN MONTH_NAME2 like ('Dec') then CONCAT (LEFT (CURRENTJOBDATE2,4),'-','12','-','01')
else CONCAT (LEFT (CURRENTJOBDATE2,4),'-','01','-','01')
end AS CURRENTJOBDATE2
from ""LINK"".""PUBLIC"".""DURATION_NEW"") B
ON A.PROFILELINK=B.PROFILELINK

Join

(
SELECT PROFILELINK,CURRENTJOB3,
CASE when CURRENTJOBDATE3 in ('- P-202-01', '- P-201-01', '-190-01', '--01','- P-01-01') then CONCAT ('1900','-','01','-','01') 
WHEN MONTH_NAME3 like ('Jan') then CONCAT (LEFT (CURRENTJOBDATE3,4),'-','01','-','01')
WHEN MONTH_NAME3 like ('Feb') then CONCAT (LEFT (CURRENTJOBDATE3,4),'-','02','-','01') 
WHEN MONTH_NAME3  like ('Mar') then CONCAT (LEFT (CURRENTJOBDATE3,4),'-','03','-','01')
WHEN MONTH_NAME3  like ('Apr') then CONCAT (LEFT (CURRENTJOBDATE3,4),'-','04','-','01')
WHEN MONTH_NAME3  like ('May') then CONCAT (LEFT (CURRENTJOBDATE3,4),'-','05','-','01')
WHEN MONTH_NAME3  like ('Jun') then CONCAT (LEFT (CURRENTJOBDATE3,4),'-','06','-','01')
WHEN MONTH_NAME3 like ('Jul') then CONCAT (LEFT (CURRENTJOBDATE3,4),'-','07','-','01')
WHEN MONTH_NAME3 like ('Aug') then CONCAT (LEFT (CURRENTJOBDATE3,4),'-','08','-','01')
WHEN MONTH_NAME3 like ('Sep') then CONCAT (LEFT (CURRENTJOBDATE3,4),'-','09','-','01')
WHEN MONTH_NAME3 like ('Oct') then CONCAT (LEFT (CURRENTJOBDATE3,4),'-','10','-','01')
WHEN MONTH_NAME3 like ('Nov') then CONCAT (LEFT (CURRENTJOBDATE3,4),'-','11','-','01')
WHEN MONTH_NAME3 like ('Dec') then CONCAT (LEFT (CURRENTJOBDATE3,4),'-','12','-','01')
else CONCAT (LEFT (CURRENTJOBDATE3,4),'-','01','-','01')
end AS CURRENTJOBDATE3
from ""LINK"".""PUBLIC"".""DURATION_NEW"") c
ON A.PROFILELINK=c.PROFILELINK
                                      
JOIN

(
SELECT PROFILELINK,LASTJOB, 
CASE when LASTJOBDATE1_BEGIN in ('- P-202-01', '- P-201-01', '-190-01', '--01','- P-01-01') then CONCAT ('1900','-','01','-','01')
WHEN LASTMONTH_NAME1_BEGIN like ('Jan') then CONCAT (LEFT (LASTJOBDATE1_BEGIN,4),'-','01','-','01')
WHEN LASTMONTH_NAME1_BEGIN like ('Feb') then CONCAT (LEFT (LASTJOBDATE1_BEGIN,4),'-','02','-','01')
WHEN LASTMONTH_NAME1_BEGIN  like ('Mar') then CONCAT (LEFT (LASTJOBDATE1_BEGIN,4),'-','03','-','01')
WHEN LASTMONTH_NAME1_BEGIN  like ('Apr') then CONCAT (LEFT (LASTJOBDATE1_BEGIN,4),'-','04','-','01')
WHEN LASTMONTH_NAME1_BEGIN  like ('May') then CONCAT (LEFT (LASTJOBDATE1_BEGIN,4),'-','05','-','01')
WHEN LASTMONTH_NAME1_BEGIN  like ('Jun') then CONCAT (LEFT (LASTJOBDATE1_BEGIN,4),'-','06','-','01')
WHEN LASTMONTH_NAME1_BEGIN like ('Jul') then CONCAT (LEFT (LASTJOBDATE1_BEGIN,4),'-','07','-','01')
WHEN LASTMONTH_NAME1_BEGIN like ('Aug') then CONCAT (LEFT (LASTJOBDATE1_BEGIN,4),'-','08','-','01')
WHEN LASTMONTH_NAME1_BEGIN like ('Sep') then CONCAT (LEFT (LASTJOBDATE1_BEGIN,4),'-','09','-','01')
WHEN LASTMONTH_NAME1_BEGIN like ('Oct') then CONCAT (LEFT (LASTJOBDATE1_BEGIN,4),'-','10','-','01')
WHEN LASTMONTH_NAME1_BEGIN like ('Nov') then CONCAT (LEFT (LASTJOBDATE1_BEGIN,4),'-','11','-','01')
WHEN LASTMONTH_NAME1_BEGIN like ('Dec') then CONCAT (LEFT (LASTJOBDATE1_BEGIN,4),'-','12','-','01')
else CONCAT (LEFT (LASTJOBDATE1_BEGIN,4),'-','01','-','01')
end AS LASTJOBDATE1_BEGIN
FROM ""LINK"".""PUBLIC"".""DURATION_NEW"") D
ON A.PROFILELINK= D.PROFILELINK

JOIN 

(SELECT PROFILELINK,LASTJOB, 
CASE when LASTJOBDATE1_FINISH in ('- P-202-01', '- P-201-01', '-190-01', '--01','- P-01-01') then CONCAT ('1900','-','01','-','01')
WHEN LASTMONTH_NAME1_FINISH like ('Jan') then CONCAT (LEFT (LASTJOBDATE1_FINISH,4),'-','01','-','01')
WHEN LASTMONTH_NAME1_FINISH like ('Feb') then CONCAT (LEFT (LASTJOBDATE1_FINISH,4),'-','02','-','01') 
WHEN LASTMONTH_NAME1_FINISH  like ('Mar') then CONCAT (LEFT (LASTJOBDATE1_FINISH,4),'-','03','-','01')
WHEN LASTMONTH_NAME1_FINISH  like ('Apr') then CONCAT (LEFT (LASTJOBDATE1_FINISH,4),'-','04','-','01')
WHEN LASTMONTH_NAME1_FINISH  like ('May') then CONCAT (LEFT (LASTJOBDATE1_FINISH,4),'-','05','-','01')
WHEN LASTMONTH_NAME1_FINISH  like ('Jun') then CONCAT (LEFT (LASTJOBDATE1_FINISH,4),'-','06','-','01')
WHEN LASTMONTH_NAME1_FINISH like ('Jul') then CONCAT (LEFT (LASTJOBDATE1_FINISH,4),'-','07','-','01')
WHEN LASTMONTH_NAME1_FINISH like ('Aug') then CONCAT (LEFT (LASTJOBDATE1_FINISH,4),'-','08','-','01')
WHEN LASTMONTH_NAME1_FINISH like ('Sep') then CONCAT (LEFT (LASTJOBDATE1_FINISH,4),'-','09','-','01')
WHEN LASTMONTH_NAME1_FINISH like ('Oct') then CONCAT (LEFT (LASTJOBDATE1_FINISH,4),'-','10','-','01')
WHEN LASTMONTH_NAME1_FINISH like ('Nov') then CONCAT (LEFT (LASTJOBDATE1_FINISH,4),'-','11','-','01')
WHEN LASTMONTH_NAME1_FINISH like ('Dec') then CONCAT (LEFT (LASTJOBDATE1_FINISH,4),'-','12','-','01')
else CONCAT (LEFT (LASTJOBDATE1_FINISH,4),'-','01','-','01')
end AS LASTJOBDATE1_FINISH
FROM ""LINK"".""PUBLIC"".""DURATION_NEW"") E
ON A.PROFILELINK= E.PROFILELINK

JOIN 
(SELECT PROFILELINK,PASTJOB2,
CASE when PASTJOBDATE2_BEGIN in ('- P-202-01', '- P-201-01', '-190-01', '--01','- P-01-01') then CONCAT ('1900','-','01','-','01')
WHEN LASTMONTH_NAME1_FINISH like ('Jan') then CONCAT (LEFT (PASTJOBDATE2_BEGIN,4),'-','01','-','01')
WHEN LASTMONTH_NAME1_FINISH like ('Feb') then CONCAT (LEFT (PASTJOBDATE2_BEGIN,4),'-','02','-','01') 
WHEN LASTMONTH_NAME1_FINISH  like ('Mar') then CONCAT (LEFT (PASTJOBDATE2_BEGIN,4),'-','03','-','01')
WHEN LASTMONTH_NAME1_FINISH  like ('Apr') then CONCAT (LEFT (PASTJOBDATE2_BEGIN,4),'-','04','-','01')
WHEN LASTMONTH_NAME1_FINISH  like ('May') then CONCAT (LEFT (PASTJOBDATE2_BEGIN,4),'-','05','-','01')
WHEN LASTMONTH_NAME1_FINISH  like ('Jun') then CONCAT (LEFT (PASTJOBDATE2_BEGIN,4),'-','06','-','01')
WHEN LASTMONTH_NAME1_FINISH like ('Jul') then CONCAT (LEFT (PASTJOBDATE2_BEGIN,4),'-','07','-','01')
WHEN LASTMONTH_NAME1_FINISH like ('Aug') then CONCAT (LEFT (PASTJOBDATE2_BEGIN,4),'-','08','-','01')
WHEN LASTMONTH_NAME1_FINISH like ('Sep') then CONCAT (LEFT (PASTJOBDATE2_BEGIN,4),'-','09','-','01')
WHEN LASTMONTH_NAME1_FINISH like ('Oct') then CONCAT (LEFT (PASTJOBDATE2_BEGIN,4),'-','10','-','01')
WHEN LASTMONTH_NAME1_FINISH like ('Nov') then CONCAT (LEFT (PASTJOBDATE2_BEGIN,4),'-','11','-','01')
WHEN LASTMONTH_NAME1_FINISH like ('Dec') then CONCAT (LEFT (PASTJOBDATE2_BEGIN,4),'-','12','-','01')
else CONCAT (LEFT (PASTJOBDATE2_BEGIN,4),'-','01','-','01')
end AS PASTJOBDATE2_BEGIN
FROM ""LINK"".""PUBLIC"".""DURATION_NEW"") F
ON A.PROFILELINK= F.PROFILELINK

JOIN 
(SELECT PROFILELINK, PASTJOB2,
CASE when PASTJOBDATE2_FINISH  in ('- P-202-01', '- P-201-01', '-190-01', '--01','- P-01-01') then CONCAT ('1900','-','01','-','01')
WHEN PASTJOBMONTH_NAME2_FINISH like ('Jan') then CONCAT (LEFT (PASTJOBDATE2_FINISH,4),'-','01','-','01')
WHEN PASTJOBMONTH_NAME2_FINISH like ('Feb') then CONCAT (LEFT (PASTJOBDATE2_FINISH,4),'-','02','-','01') 
WHEN PASTJOBMONTH_NAME2_FINISH  like ('Mar') then CONCAT (LEFT (PASTJOBDATE2_FINISH,4),'-','03','-','01')
WHEN PASTJOBMONTH_NAME2_FINISH  like ('Apr') then CONCAT (LEFT (PASTJOBDATE2_FINISH,4),'-','04','-','01')
WHEN PASTJOBMONTH_NAME2_FINISH  like ('May') then CONCAT (LEFT (PASTJOBDATE2_FINISH,4),'-','05','-','01')
WHEN PASTJOBMONTH_NAME2_FINISH  like ('Jun') then CONCAT (LEFT (PASTJOBDATE2_FINISH,4),'-','06','-','01')
WHEN PASTJOBMONTH_NAME2_FINISH like ('Jul') then CONCAT (LEFT (PASTJOBDATE2_FINISH,4),'-','07','-','01')
WHEN PASTJOBMONTH_NAME2_FINISH like ('Aug') then CONCAT (LEFT (PASTJOBDATE2_FINISH,4),'-','08','-','01')
WHEN PASTJOBMONTH_NAME2_FINISH like ('Sep') then CONCAT (LEFT (PASTJOBDATE2_FINISH,4),'-','09','-','01')
WHEN PASTJOBMONTH_NAME2_FINISH like ('Oct') then CONCAT (LEFT (PASTJOBDATE2_FINISH,4),'-','10','-','01')
WHEN PASTJOBMONTH_NAME2_FINISH like ('Nov') then CONCAT (LEFT (PASTJOBDATE2_FINISH,4),'-','11','-','01')
WHEN PASTJOBMONTH_NAME2_FINISH like ('Dec') then CONCAT (LEFT (PASTJOBDATE2_FINISH,4),'-','12','-','01')
else CONCAT (LEFT (PASTJOBDATE2_FINISH,4),'-','01','-','01')
end AS PASTJOBDATE2_FINISH
FROM ""LINK"".""PUBLIC"".""DURATION_NEW"") G
ON A.PROFILELINK= G.PROFILELINK

JOIN 
(SELECT PROFILELINK, PASTJOB3,
CASE when PASTJOBDATE3_BEGIN  in ('- P-202-01', '- P-201-01', '-190-01', '--01','- P-01-01') then CONCAT ('1900','-','01','-','01')
WHEN PASTJOBMONTH_NAME3_BEGIN like ('Jan') then CONCAT (LEFT (PASTJOBDATE3_BEGIN,4),'-','01','-','01')
WHEN PASTJOBMONTH_NAME3_BEGIN like ('Feb') then CONCAT (LEFT (PASTJOBDATE3_BEGIN,4),'-','02','-','01') 
WHEN PASTJOBMONTH_NAME3_BEGIN  like ('Mar') then CONCAT (LEFT (PASTJOBDATE3_BEGIN,4),'-','03','-','01')
WHEN PASTJOBMONTH_NAME3_BEGIN  like ('Apr') then CONCAT (LEFT (PASTJOBDATE3_BEGIN,4),'-','04','-','01')
WHEN PASTJOBMONTH_NAME3_BEGIN  like ('May') then CONCAT (LEFT (PASTJOBDATE3_BEGIN,4),'-','05','-','01')
WHEN PASTJOBMONTH_NAME3_BEGIN  like ('Jun') then CONCAT (LEFT (PASTJOBDATE3_BEGIN,4),'-','06','-','01')
WHEN PASTJOBMONTH_NAME3_BEGIN like ('Jul') then CONCAT (LEFT (PASTJOBDATE3_BEGIN,4),'-','07','-','01')
WHEN PASTJOBMONTH_NAME3_BEGIN like ('Aug') then CONCAT (LEFT (PASTJOBDATE3_BEGIN,4),'-','08','-','01')
WHEN PASTJOBMONTH_NAME3_BEGIN like ('Sep') then CONCAT (LEFT (PASTJOBDATE3_BEGIN,4),'-','09','-','01')
WHEN PASTJOBMONTH_NAME3_BEGIN like ('Oct') then CONCAT (LEFT (PASTJOBDATE3_BEGIN,4),'-','10','-','01')
WHEN PASTJOBMONTH_NAME3_BEGIN like ('Nov') then CONCAT (LEFT (PASTJOBDATE3_BEGIN,4),'-','11','-','01')
WHEN PASTJOBMONTH_NAME3_BEGIN like ('Dec') then CONCAT (LEFT (PASTJOBDATE3_BEGIN,4),'-','12','-','01')
else CONCAT (LEFT (PASTJOBDATE3_BEGIN,4),'-','01','-','01')
end AS PASTJOBDATE3_BEGIN
FROM ""LINK"".""PUBLIC"".""DURATION_NEW"") H
ON A.PROFILELINK= H.PROFILELINK

JOIN
(SELECT PROFILELINK,PASTJOB3,
CASE when PASTJOBDATE3_FINISH  in ('- P-202-01', '- P-201-01', '-190-01', '--01','- P-01-01') then CONCAT ('1900','-','01','-','01') 
WHEN PASTJOBMONTH_NAME3_FINISH like ('Jan') then CONCAT (LEFT (PASTJOBDATE3_FINISH,4),'-','01','-','01')
WHEN PASTJOBMONTH_NAME3_FINISH like ('Feb') then CONCAT (LEFT (PASTJOBDATE3_FINISH,4),'-','02','-','01')
WHEN PASTJOBMONTH_NAME3_FINISH  like ('Mar') then CONCAT (LEFT (PASTJOBDATE3_FINISH,4),'-','03','-','01')
WHEN PASTJOBMONTH_NAME3_FINISH  like ('Apr') then CONCAT (LEFT (PASTJOBDATE3_FINISH,4),'-','04','-','01')
WHEN PASTJOBMONTH_NAME3_FINISH  like ('May') then CONCAT (LEFT (PASTJOBDATE3_FINISH,4),'-','05','-','01')
WHEN PASTJOBMONTH_NAME3_FINISH  like ('Jun') then CONCAT (LEFT (PASTJOBDATE3_FINISH,4),'-','06','-','01')
WHEN PASTJOBMONTH_NAME3_FINISH like ('Jul') then CONCAT (LEFT (PASTJOBDATE3_FINISH,4),'-','07','-','01')
WHEN PASTJOBMONTH_NAME3_FINISH like ('Aug') then CONCAT (LEFT (PASTJOBDATE3_FINISH,4),'-','08','-','01')
WHEN PASTJOBMONTH_NAME3_FINISH like ('Sep') then CONCAT (LEFT (PASTJOBDATE3_FINISH,4),'-','09','-','01')
WHEN PASTJOBMONTH_NAME3_FINISH like ('Oct') then CONCAT (LEFT (PASTJOBDATE3_FINISH,4),'-','10','-','01')
WHEN PASTJOBMONTH_NAME3_FINISH like ('Nov') then CONCAT (LEFT (PASTJOBDATE3_FINISH,4),'-','11','-','01')
WHEN PASTJOBMONTH_NAME3_FINISH like ('Dec') then CONCAT (LEFT (PASTJOBDATE3_FINISH,4),'-','12','-','01')
else CONCAT (LEFT (PASTJOBDATE3_FINISH,4),'-','01','-','01')
end AS PASTJOBDATE3_FINISH
FROM ""LINK"".""PUBLIC"".""DURATION_NEW"") I
ON A.PROFILELINK= I.PROFILELINK


) 
  
  
  NEW4


);"
```

### 6) Bussiness Question - What is the Percentage of experienced Military veterans?
```sql
view 1

create or replace view LINK.PUBLIC.IDF(
        PROFILELINK,
        CURRENTJOB,
        COMPANY1,
        CURRENTJOB2,
        CURRENTCOMPANY2,
        CURRENTJOB3,
        CURRENTCOMPANY3,
        LASTJOB,
        LASTJOB_COMPANY,
        PASTJOB2,
        PASTCOMPANY2,
        PASTJOB3,
        PASTCOMPANY3
) as
SELECT profilelink,CURRENTJOB,company1,CURRENTJOB2,CURRENTCOMPANY2,CURRENTJOB3,CURRENTCOMPANY3,LASTJOB,LASTJOB_COMPANY,PASTJOB2,PASTCOMPANY2,PASTJOB3,PASTCOMPANY3
FROM LINK.PUBLIC.LINKEDIN
WHERE company1 LIKE ANY('%IDF%','%8200%','%Israel Defense Forces%','%MILITARY%','%Intelligence%','%9900%') AND currentjob LIKE ('%Analyst%')
OR  CURRENTCOMPANY2 LIKE ANY('%IDF%','%8200%','%Israel Defense Forces%','%MILITARY%','%Intelligence%','%9900%') AND CURRENTJOB2 LIKE ('%Analyst%')
OR CURRENTCOMPANY3 LIKE ANY ('%IDF%','%8200%','%Israel Defense Forces%','%MILITARY%','%Intelligence%','%9900%') AND CURRENTJOB3 LIKE ('%Analyst%')
OR LASTJOB_COMPANY LIKE ANY ('%IDF%','%8200%','%Israel Defense Forces%','%MILITARY%','%Intelligence%','%9900%') AND  LASTJOB LIKE ('%Analyst%')
OR PASTCOMPANY2 LIKE ANY ('%IDF%','%8200%','%Israel Defense Forces%','%MILITARY%','%Intelligence%','%9900%') AND PASTJOB2 LIKE ('%Analyst%')
OR PASTCOMPANY3 LIKE ANY ('%IDF%','%8200%','%Israel Defense Forces%','%MILITARY%','%Intelligence%','%9900%') AND PASTJOB3 LIKE ('%Analyst%');"
```
