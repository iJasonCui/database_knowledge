--===============
--both
--===============
use tempdb
go
/*
--ase 12.5
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
*/
--ASE 15
CREATE TABLE dbo.sysloginsSource
(
    suid          int            NOT NULL,
    status        smallint       NOT NULL,
    accdate       datetime       NOT NULL,
    totcpu        int            NOT NULL,
    totio         int            NOT NULL,
    spacelimit    int            NOT NULL,
    timelimit     int            NOT NULL,
    resultlimit   int            NOT NULL,
    dbname        varchar(30)    NULL,
    name          varchar(30)    NOT NULL,
    password      varbinary(128) NULL,
    language      varchar(30)    NULL,
    pwdate        datetime       NULL,
    audflags      int            NULL,
    fullname      varchar(30)    NULL,
    srvname       varchar(30)    NULL,
    logincount    smallint       NULL,
    procid        int            NULL,
    lastlogindate datetime       NULL,
    crdate        datetime       NULL,
    locksuid      int            NULL,
    lockreason    int            NULL,
    lockdate      datetime       NULL
)
LOCK DATAROWS
go

CREATE TABLE dbo.sysloginrolesSource
(
    suid   smallint NOT NULL,
    srid   smallint NOT NULL,
    status smallint NOT NULL
)
--======================
--source
--=======================
insert tempdb..sysloginsSource
select  * from  master..syslogins where suid > = 3

insert tempdb..sysloginrolesSource
select * from  master..sysloginroles where suid > = 3

--==================
--dest
--==================
insert master..syslogins
select * from tempdb..sysloginsSource where suid > = 3

insert master..sysloginroles
select * from tempdb..sysloginrolesSource where suid > = 3

select * from  master..sysloginroles where suid > = 3 and suid < 23
--delete from  master..sysloginroles where suid > = 3 and suid < 23
--delete from  master..syslogins where suid > = 3

select * from master..syslogins where suid = 27

--dest
--delete  from master..sysloginroles where suid = 1 and status = 0
select * from master..sysloginroles where suid = 1 and status = 0
--update master..syslogins set name = "ccdmaint" where suid = 27



		

		

