--both
use tempdb
go

--drop table sysloginsSource
CREATE TABLE dbo.sysloginsSource
(
    suid        smallint      NOT NULL,
    status      smallint      NOT NULL,
    accdate     datetime      NOT NULL,
    totcpu      int           NOT NULL,
    totio       int           NOT NULL,
    spacelimit  int           NOT NULL,
    timelimit   int           NOT NULL,
    resultlimit int           NOT NULL,
    dbname      varchar(30)   NOT NULL,
    name        varchar(30)   NOT NULL,
    password    varbinary(30) NULL,
    language    varchar(30)   NULL,
    pwdate      datetime      NULL,
    audflags    int           NULL,
    fullname    varchar(30)   NULL,
    srvname     varchar(30)   NULL,
    logincount  smallint      NULL,
    procid      int        null
)
--drop table sysloginrolesSource
CREATE TABLE dbo.sysloginrolesSource
(
    suid   smallint NOT NULL,
    srid   smallint NOT NULL,
    status smallint NOT NULL
)

--source
insert tempdb..sysloginsSource
select * from  master..syslogins where suid > = 3

insert tempdb..sysloginrolesSource
select * from  master..sysloginroles where suid > = 3

--dest


insert master..syslogins (
    suid       ,
    status     ,
    accdate    ,
    totcpu     ,
    totio      ,
    spacelimit ,
    timelimit   ,
    resultlimit ,
    dbname      ,
    name        ,
    password    ,
    language    ,
    pwdate      ,
    audflags    ,
    fullname    ,
    srvname     ,
    logincount  ,
    procid      
    )
select     suid       ,
    status     ,
    accdate    ,
    totcpu     ,
    totio      ,
    spacelimit ,
    timelimit   ,
    resultlimit ,
    dbname      ,
    name        ,
    password    ,
    language    ,
    pwdate      ,
    audflags    ,
    fullname    ,
    srvname     ,
    logincount  ,
    procid      
 from tempdb..sysloginsSource where suid > = 3

--insert master..sysloginroles
select * from tempdb..sysloginrolesSource where suid > = 3 
and suid < 23


select * from  master..sysloginroles where suid > = 3 and suid < 23
--delete from  master..sysloginrolesSource where suid > = 3 and suid < 23

select * from master..syslogins

--dest
--delete  from master..sysloginroles where suid = 1 and status = 0
select * from master..sysloginroles where suid = 1 and status = 0

		

--compare between servers

select a.suid, a.name, b.name, a.password, b.password 	
from tempdb..sysloginsSource12 a,  tempdb..sysloginsSource18 b
where a.suid *= b.suid
