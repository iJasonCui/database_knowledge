create table monEngineIn ( 
        EngineNumber            smallint,
        CPUTime         int,
        SystemCPUTime           int,
        UserCPUTime             int,
        Connections             int,
        StartTime               datetime NULL,
        SQLServerId             smallint,
        DateCreated             datetime 
) 


CREATE TABLE dbo.SQLServerProfile
(
    SQLServerId   smallint    NOT NULL,
    SQLServerName varchar(30) NOT NULL,
    HostName      varchar(30) NOT NULL,
    PortNumber    smallint    NOT NULL
)
LOCK ALLPAGES
go
IF OBJECT_ID('dbo.SQLServerProfile') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.SQLServerProfile >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.SQLServerProfile >>>'
go
CREATE UNIQUE INDEX XPKSQLServerProfile
    ON dbo.SQLServerProfile(SQLServerId)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.SQLServerProfile') AND name='XPKSQLServerProfile')
    PRINT '<<< CREATED INDEX dbo.SQLServerProfile.XPKSQLServerProfile >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.SQLServerProfile.XPKSQLServerProfile >>>'
go
CREATE UNIQUE INDEX XAK1SQLServerProfile
    ON dbo.SQLServerProfile(SQLServerName)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.SQLServerProfile') AND name='XAK1SQLServerProfile')
    PRINT '<<< CREATED INDEX dbo.SQLServerProfile.XAK1SQLServerProfile >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.SQLServerProfile.XAK1SQLServerProfile >>>'
go
CREATE UNIQUE INDEX XAK2SQLServerProfile
    ON dbo.SQLServerProfile(HostName,PortNumber)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.SQLServerProfile') AND name='XAK2SQLServerProfile')
    PRINT '<<< CREATED INDEX dbo.SQLServerProfile.XAK2SQLServerProfile >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.SQLServerProfile.XAK2SQLServerProfile >>>'
go
--
-- TABLE INSERT STATEMENTS
--
INSERT INTO dbo.SQLServerProfile ( SQLServerId, SQLServerName, HostName, PortNumber ) 
		 VALUES ( 20, '[SERVER_NAME1]', '[SERVER_NAME1]', 4100 ) 
go
INSERT INTO dbo.SQLServerProfile ( SQLServerId, SQLServerName, HostName, PortNumber ) 
		 VALUES ( 21, '[SERVER_NAME2]', '[SERVER_NAME2]', 4100 ) 
go

