Bussiness Question - What is the Percentage of Analysts that Work Part Time vs Full Time?

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
