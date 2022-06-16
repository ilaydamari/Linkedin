Bussiness Question - In what areas do most Analysts work at?

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

