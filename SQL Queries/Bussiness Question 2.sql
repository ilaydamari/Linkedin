Bussiness Question - Wich Degree is the most common between Data Analysts?

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
     or PART1_EDUC like '%industrial engineering%' or PART1_EDUC like '%??????????%' or  PART1_EDUC like '%Industrial engineering%' or PART1_EDUC like '%Industrial and Management%'
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
     or PART1_EDUC like '%industrial engineering%' or PART1_EDUC like '%??????????%' or  PART1_EDUC like '%Industrial engineering%' or PART1_EDUC like '%Industrial and Management%'
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
