Step 1: download 

http://ip-to-country.webhosting.info/node/view/6

step 2: save the .csv into text file (tab deliminated)

step 3: 

use tempdb
go

CREATE TABLE dbo.IPCountryMap_IN 
(
    ipFrom       numeric(12,0) NULL,
    ipTo         numeric(12,0) NULL,
    countryCode2 char(2)       NULL,
    countryCode3 char(3)       NULL,
    countryName  varchar(64)   NULL
)
LOCK ALLPAGES
go

step 4: bcp  ip-to-country in tempdb..IPCountryMap_IN 

step 5: delete IPCountryMap_IN where ipFrom is null

step 6: 

CREATE TABLE dbo.IPCountryMap 
(
    ipFrom       numeric(12,0) NOT NULL,
    ipTo         numeric(12,0) NOT NULL,
    countryCode2 char(2)       NOT NULL,
    countryCode3 char(3)       NOT NULL,
    countryName  varchar(64)   NULL
)
LOCK ALLPAGES
go
IF OBJECT_ID('dbo.IPCountryMap') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.IPCountryMap >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.IPCountryMap >>>'
go

CREATE UNIQUE INDEX XPKIPCountryMap
    ON dbo.IPCountryMap(ipFrom,ipTo)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.IPCountryMap') AND name='XPKIPCountryMap')
    PRINT '<<< CREATED INDEX dbo.IPCountryMap.XPKIPCountryMap >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.IPCountryMap.XPKIPCountryMap >>>'
go

CREATE UNIQUE INDEX XAK1IPCountryMap
    ON dbo.IPCountryMap(ipFrom,ipTo,countryCode2)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.IPCountryMap') AND name='XAK1IPCountryMap')
    PRINT '<<< CREATED INDEX dbo.IPCountryMap.XAK1IPCountryMap >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.IPCountryMap.XAK1IPCountryMap >>>'
go

--step 7:
insert tempdb..IPCountryMap select * from tempdb..IPCountryMap_IN 

--step 8:
select * into tempdb..IPCountryMap_old from Member..IPCountryMap m

--step 9:
--100 percent match
select m.* into tempdb..IPCountryMap_match100
from Member..IPCountryMap m, tempdb..IPCountryMap t
where m.ipFrom = t.ipFrom and m.ipTo = t.ipTo and m.countryCode2 = t.countryCode2 and m.countryCode3 = t.countryCode3 and m.countryName = t.countryName

--step 10:
--old file delete list
select convert(varchar(16),t.ipFrom) + t.countryCode2 + convert(varchar(16),t.ipTo)  as id 
into tempdb..IPCountryMap_Match_List
from tempdb..IPCountryMap_match100 t

--step 11:
drop table tempdb..IPCountryMap_old_NotMatch
select m.* into tempdb..IPCountryMap_old_NotMatch
from Member..IPCountryMap m
where convert(varchar(16),m.ipFrom) + m.countryCode2 + convert(varchar(16),m.ipTo) not in 
( select id from tempdb..IPCountryMap_Match_List)

--step 12:
--new file insert list 

drop table tempdb..IPCountryMap_new_NotMatch
select m.* 
into tempdb..IPCountryMap_new_NotMatch
from tempdb..IPCountryMap m ( INDEX XAK1IPCountryMap)
where convert(varchar(16),m.ipFrom) + m.countryCode2 + convert(varchar(16),m.ipTo) not in 
( select id from tempdb..IPCountryMap_Match_List)

select "delete from IPCountryMap where ipFrom = " + convert(varchar(16), ipFrom ) + " and ipTo = " + convert(varchar(16), ipTo) 
from IPCountryMap_old_NotMatch 

select 'INSERT IPCountryMap VALUES (' + 
     convert(varchar(16), ipFrom ) + ',' +
     convert(varchar(16), ipTo) + ',"' +
     countryCode2 + '","' + countryCode3 + '","' + countryName + '")'
from IPCountryMap_new_NotMatch a
