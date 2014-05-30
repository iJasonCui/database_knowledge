--sp_reptostandby RepTestDB_REP, 'all'

select * from RepTestDB..RepTest 

USE RepTestDB
go
CREATE UNIQUE NONCLUSTERED INDEX XPK_RepTest
    ON dbo.RepTest(repTestId)
go


CREATE TABLE dbo.RepTest1
(
    RepTestId       int      NOT NULL,
    dateTime        datetime NOT NULL,
    defaultDateTime datetime DEFAULT GETDATE() NULL
)
LOCK ALLPAGES
go
IF OBJECT_ID('dbo.RepTest1') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.RepTest1 >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.RepTest1 >>>'
go
CREATE UNIQUE NONCLUSTERED INDEX XPK_RepTest1
    ON dbo.RepTest1(RepTestId)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.RepTest1') AND name='XPK_RepTest1')
    PRINT '<<< CREATED INDEX dbo.RepTest1.XPK_RepTest1 >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.RepTest1.XPK_RepTest1 >>>'
go

insert RepTestDB..RepTest  values (1, getdate(), getdate())
insert RepTestDB..RepTest  values (2, getdate(), getdate())
insert RepTestDB..RepTest  values (3, getdate(), getdate())

truncate table RepTestDB_WS..RepTest
truncate table RepTestDB_WS..RepTest1

select * into RepTestDB_WS..RepTest2 from  RepTestDB_WS..RepTest

delete from RepTestDB..RepTest

select * from RepTestDB_WS..RepTest 

sp_setreptable RepTest, true


insert RepTestDB..RepTest1  values (1, getdate(), getdate())
insert RepTestDB..RepTest1  values (2, getdate(), getdate())
insert RepTestDB..RepTest1  values (3, getdate(), getdate())


select * from RepTestDB_WS..RepTest1 


exec sp_stop_rep_agent RepTestDB

exec sp_start_rep_agent RepTestDB_WS 