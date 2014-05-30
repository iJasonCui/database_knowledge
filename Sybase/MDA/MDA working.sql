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
		 VALUES ( 20, 'webdb20p', 'webdb20p', 4100 ) 
go
INSERT INTO dbo.SQLServerProfile ( SQLServerId, SQLServerName, HostName, PortNumber ) 
		 VALUES ( 21, 'webdb21p', 'webdb21p', 4100 ) 
go
INSERT INTO dbo.SQLServerProfile ( SQLServerId, SQLServerName, HostName, PortNumber ) 
		 VALUES ( 22, 'webdb22p', 'webdb22p', 4100 ) 
go
INSERT INTO dbo.SQLServerProfile ( SQLServerId, SQLServerName, HostName, PortNumber ) 
		 VALUES ( 23, 'webdb23p', 'webdb23p', 4100 ) 
go
INSERT INTO dbo.SQLServerProfile ( SQLServerId, SQLServerName, HostName, PortNumber ) 
		 VALUES ( 24, 'webdb24p', 'webdb24p', 4100 ) 
go
INSERT INTO dbo.SQLServerProfile ( SQLServerId, SQLServerName, HostName, PortNumber ) 
		 VALUES ( 25, 'webdb25p', 'webdb25p', 4100 ) 
go
INSERT INTO dbo.SQLServerProfile ( SQLServerId, SQLServerName, HostName, PortNumber ) 
		 VALUES ( 27, 'webdb27p', 'webdb27p', 4100 ) 
go
INSERT INTO dbo.SQLServerProfile ( SQLServerId, SQLServerName, HostName, PortNumber ) 
		 VALUES ( 28, 'webdb28p', 'webdb28p', 4100 ) 
go
INSERT INTO dbo.SQLServerProfile ( SQLServerId, SQLServerName, HostName, PortNumber ) 
		 VALUES ( 29, 'webdb29p', 'webdb29p', 4100 ) 
go
INSERT INTO dbo.SQLServerProfile ( SQLServerId, SQLServerName, HostName, PortNumber ) 
		 VALUES ( 30, 'webdb30p', 'webdb30p', 4100 ) 
go
INSERT INTO dbo.SQLServerProfile ( SQLServerId, SQLServerName, HostName, PortNumber ) 
		 VALUES ( 31, 'webdb31p', 'webdb31p', 4100 ) 
go
INSERT INTO dbo.SQLServerProfile ( SQLServerId, SQLServerName, HostName, PortNumber ) 
		 VALUES ( 1001, 'webdb0g', 'webdb0g', 4100 ) 
go
INSERT INTO dbo.SQLServerProfile ( SQLServerId, SQLServerName, HostName, PortNumber ) 
		 VALUES ( 1002, 'webdb0t', 'webdb0g', 7200 ) 
go
INSERT INTO dbo.SQLServerProfile ( SQLServerId, SQLServerName, HostName, PortNumber ) 
		 VALUES ( 1003, 'webdb1g', 'webdb1g', 4100 ) 
go
INSERT INTO dbo.SQLServerProfile ( SQLServerId, SQLServerName, HostName, PortNumber ) 
		 VALUES ( 1004, 'webdb1d', 'webdb1g', 7100 ) 
go
INSERT INTO dbo.SQLServerProfile ( SQLServerId, SQLServerName, HostName, PortNumber ) 
		 VALUES ( 1005, 'webdb0r', 'webdb0r', 4100 ) 
go
