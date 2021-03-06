Bussiness Question - What is the Percentage of experienced Military veterans?

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
