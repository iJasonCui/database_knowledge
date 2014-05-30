--===========================
-- DATABASE
--===========================
USE master
go
CREATE DATABASE repStats
    ON wdata1=2048
    LOG ON wlog1=512
go
USE master
go
EXEC sp_dboption 'repStats','dbo use only',true
go
EXEC sp_dboption 'repStats','select into/bulkcopy/pllsort',true
go
EXEC sp_dboption 'repStats','trunc log on chkpt',true
go
USE repStats
go
CHECKPOINT
go
USE repStats
go
EXEC sp_changedbowner 'sa'
go
IF DB_ID('repStats') IS NOT NULL
    PRINT '<<< CREATED DATABASE repStats >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE repStats >>>'
go
--=====================================
--TABLES
--=====================================

CREATE TABLE dbo.PrimaryDB
(
    primaryDBId    int         NOT NULL,
    primaryDBName  varchar(30) NOT NULL,
    primarySRVName varchar(30) NOT NULL,
    primaryFlag    char(1)     NOT NULL,
    maintUserName  varchar(30) NOT NULL,
    maintUserPass  varchar(30) NOT NULL
)
LOCK ALLPAGES
go
IF OBJECT_ID('dbo.PrimaryDB') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.PrimaryDB >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.PrimaryDB >>>'
go
CREATE UNIQUE NONCLUSTERED INDEX XPKdbId
    ON dbo.PrimaryDB(primaryDBId)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.PrimaryDB') AND name='XPKdbId')
    PRINT '<<< CREATED INDEX dbo.PrimaryDB.XPKdbId >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.PrimaryDB.XPKdbId >>>'
go
CREATE UNIQUE NONCLUSTERED INDEX XAK1DB_SRVName
    ON dbo.PrimaryDB(primaryDBName,primarySRVName)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.PrimaryDB') AND name='XAK1DB_SRVName')
    PRINT '<<< CREATED INDEX dbo.PrimaryDB.XAK1DB_SRVName >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.PrimaryDB.XAK1DB_SRVName >>>'
go

CREATE TABLE dbo.RepLatency
(
    dBServer               varchar(30) NOT NULL,
    dBName                 varchar(30) NOT NULL,
    primaryDBID            int         NOT NULL,
    latencyInSec           int         NOT NULL,
    lastXactOriginTime     datetime    NOT NULL,
    lastXactDestCommitTime datetime    NOT NULL,
    dateCreated            datetime    NOT NULL
)
LOCK ALLPAGES
go
IF OBJECT_ID('dbo.RepLatency') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.RepLatency >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.RepLatency >>>'
go
CREATE UNIQUE NONCLUSTERED INDEX XAK1_RepLatency
    ON dbo.RepLatency(dBServer,primaryDBID,lastXactOriginTime,lastXactDestCommitTime)
  WITH IGNORE_DUP_KEY
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.RepLatency') AND name='XAK1_RepLatency')
    PRINT '<<< CREATED INDEX dbo.RepLatency.XAK1_RepLatency >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.RepLatency.XAK1_RepLatency >>>'
go
CREATE NONCLUSTERED INDEX XIE1_dateCreated
    ON dbo.RepLatency(dateCreated,dBServer,dBName)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.RepLatency') AND name='XIE1_dateCreated')
    PRINT '<<< CREATED INDEX dbo.RepLatency.XIE1_dateCreated >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.RepLatency.XIE1_dateCreated >>>'
go

CREATE TABLE dbo.RepLatencyLog
(
    replicateDBId      int      NOT NULL,
    latencyInSec       int      NOT NULL,
    repTestId          int      NOT NULL,
    dateCreatedPrimary datetime NOT NULL
)
LOCK ALLPAGES
go
IF OBJECT_ID('dbo.RepLatencyLog') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.RepLatencyLog >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.RepLatencyLog >>>'
go
CREATE UNIQUE NONCLUSTERED INDEX XAK1_dbId_repTestId
    ON dbo.RepLatencyLog(replicateDBId,repTestId)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.RepLatencyLog') AND name='XAK1_dbId_repTestId')
    PRINT '<<< CREATED INDEX dbo.RepLatencyLog.XAK1_dbId_repTestId >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.RepLatencyLog.XAK1_dbId_repTestId >>>'
go

CREATE TABLE dbo.RepLatencyTest
(
    dBServer               varchar(30) NOT NULL,
    dBName                 varchar(30) NOT NULL,
    primaryDBID            int         NOT NULL,
    latencyInSec           int         NOT NULL,
    lastXactOriginTime     datetime    NOT NULL,
    lastXactDestCommitTime datetime    NOT NULL,
    dateCreated            datetime    NOT NULL
)
LOCK ALLPAGES
go
IF OBJECT_ID('dbo.RepLatencyTest') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.RepLatencyTest >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.RepLatencyTest >>>'
go
CREATE UNIQUE NONCLUSTERED INDEX XAK1_RepLatencyTest
    ON dbo.RepLatencyTest(dBServer,primaryDBID,lastXactOriginTime,lastXactDestCommitTime)
  WITH IGNORE_DUP_KEY
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.RepLatencyTest') AND name='XAK1_RepLatencyTest')
    PRINT '<<< CREATED INDEX dbo.RepLatencyTest.XAK1_RepLatencyTest >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.RepLatencyTest.XAK1_RepLatencyTest >>>'
go

CREATE TABLE dbo.ReplicateDB
(
    replicateDBId    int         NOT NULL,
    replicateDBName  varchar(30) NOT NULL,
    replicateSRVName varchar(30) NOT NULL,
    replicateFlag    char(1)     NOT NULL,
    primarySRVName   varchar(30) NOT NULL
)
LOCK ALLPAGES
go
IF OBJECT_ID('dbo.ReplicateDB') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.ReplicateDB >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.ReplicateDB >>>'
go
CREATE UNIQUE NONCLUSTERED INDEX XPKdbId
    ON dbo.ReplicateDB(replicateDBId)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.ReplicateDB') AND name='XPKdbId')
    PRINT '<<< CREATED INDEX dbo.ReplicateDB.XPKdbId >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.ReplicateDB.XPKdbId >>>'
go
CREATE UNIQUE NONCLUSTERED INDEX XAK1DB_SRVName
    ON dbo.ReplicateDB(replicateDBName,replicateSRVName)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.ReplicateDB') AND name='XAK1DB_SRVName')
    PRINT '<<< CREATED INDEX dbo.ReplicateDB.XAK1DB_SRVName >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.ReplicateDB.XAK1DB_SRVName >>>'
go

CREATE TABLE dbo.ReplicateDB_SRV
(
    serverId   int         NOT NULL,
    serverName varchar(30) NOT NULL,
    CONSTRAINT ASEServerL_1280004562
    PRIMARY KEY NONCLUSTERED (serverId)
)
LOCK ALLPAGES
go
IF OBJECT_ID('dbo.ReplicateDB_SRV') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.ReplicateDB_SRV >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.ReplicateDB_SRV >>>'
go
CREATE UNIQUE NONCLUSTERED INDEX XAK1ASEServerList
    ON dbo.ReplicateDB_SRV(serverName)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.ReplicateDB_SRV') AND name='XAK1ASEServerList')
    PRINT '<<< CREATED INDEX dbo.ReplicateDB_SRV.XAK1ASEServerList >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.ReplicateDB_SRV.XAK1ASEServerList >>>'
go

CREATE TABLE dbo.ReplicationServer
(
    repServerId       int         NOT NULL,
    repServerName     varchar(30) NOT NULL,
    rssdServerName    varchar(30) NOT NULL,
    rssdName          varchar(30) NOT NULL,
    stableQueuePrefix varchar(30) NOT NULL
)
LOCK ALLPAGES
go
IF OBJECT_ID('dbo.ReplicationServer') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.ReplicationServer >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.ReplicationServer >>>'
go
CREATE UNIQUE NONCLUSTERED INDEX XPK_RepServer
    ON dbo.ReplicationServer(repServerId)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.ReplicationServer') AND name='XPK_RepServer')
    PRINT '<<< CREATED INDEX dbo.ReplicationServer.XPK_RepServer >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.ReplicationServer.XPK_RepServer >>>'
go
CREATE UNIQUE NONCLUSTERED INDEX XAK1_repsrvName
    ON dbo.ReplicationServer(repServerName)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.ReplicationServer') AND name='XAK1_repsrvName')
    PRINT '<<< CREATED INDEX dbo.ReplicationServer.XAK1_repsrvName >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.ReplicationServer.XAK1_repsrvName >>>'
go

CREATE TABLE dbo.StableQMonitor
(
    rssdServerName   varchar(30) NOT NULL,
    stableDeviceName varchar(30) NOT NULL,
    totalSizeMB      int         NOT NULL,
    allocatedSizeMB  int         NOT NULL,
    dateCreated      datetime    NOT NULL
)
LOCK ALLPAGES
go
IF OBJECT_ID('dbo.StableQMonitor') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.StableQMonitor >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.StableQMonitor >>>'
go
CREATE UNIQUE NONCLUSTERED INDEX XAK1_rssdSRV_dateCreated
    ON dbo.StableQMonitor(rssdServerName,dateCreated)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.StableQMonitor') AND name='XAK1_rssdSRV_dateCreated')
    PRINT '<<< CREATED INDEX dbo.StableQMonitor.XAK1_rssdSRV_dateCreated >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.StableQMonitor.XAK1_rssdSRV_dateCreated >>>'
go
CREATE NONCLUSTERED INDEX XIE1_dateCreated
    ON dbo.StableQMonitor(dateCreated)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.StableQMonitor') AND name='XIE1_dateCreated')
    PRINT '<<< CREATED INDEX dbo.StableQMonitor.XIE1_dateCreated >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.StableQMonitor.XIE1_dateCreated >>>'
go

CREATE TABLE dbo.UserDefinedRepLatency
(
    serverId     int      NOT NULL,
    databaseId   int      NOT NULL,
    latencyInSec int      NOT NULL,
    dataCreated  datetime NOT NULL
)
LOCK ALLPAGES
go
IF OBJECT_ID('dbo.UserDefinedRepLatency') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.UserDefinedRepLatency >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.UserDefinedRepLatency >>>'
go
CREATE UNIQUE NONCLUSTERED INDEX XAK1URepLatency
    ON dbo.UserDefinedRepLatency(dataCreated,serverId,databaseId)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.UserDefinedRepLatency') AND name='XAK1URepLatency')
    PRINT '<<< CREATED INDEX dbo.UserDefinedRepLatency.XAK1URepLatency >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.UserDefinedRepLatency.XAK1URepLatency >>>'
go

--========================
-- VIEW
--========================

IF OBJECT_ID('dbo.sysquerymetrics') IS NOT NULL
BEGIN
    DROP VIEW dbo.sysquerymetrics
    IF OBJECT_ID('dbo.sysquerymetrics') IS NOT NULL
        PRINT '<<< FAILED DROPPING VIEW dbo.sysquerymetrics >>>'
    ELSE
        PRINT '<<< DROPPED VIEW dbo.sysquerymetrics >>>'
END
go
create view sysquerymetrics (uid, gid, hashkey, id, sequence, exec_min, exec_max, exec_avg, elap_min, elap_max, elap_avg, lio_min, lio_max, lio_avg, pio_min, pio_max, pio_avg, cnt, abort_cnt, qtext) as select  a.uid, -a.gid, a.hashkey, a.id, a.sequence, convert(int, substring(b.text, charindex('e1', b.text) + 3, charindex('e2', b.text) - charindex('e1', b.text) - 4)), convert(int, substring(b.text, charindex('e2', b.text) + 3, charindex('e3', b.text) - charindex('e2', b.text) - 4)), convert(int, substring(b.text, charindex('e3', b.text) + 3, charindex('t1', b.text) - charindex('e3', b.text) - 4)), convert(int, substring(b.text, charindex('t1', b.text) + 3, charindex('t2', b.text) - charindex('t1', b.text) - 4)), convert(int, substring(b.text, charindex('t2', b.text) + 3, charindex('t3', b.text) - charindex('t2', b.text) - 4)), convert(int, substring(b.text, charindex('t3', b.text) + 3, charindex('l1', b.text) - charindex('t3', b.text) - 4)), convert(int, substring(b.text, charindex('l1', b.text) + 3, charindex('l2', b.text) - charindex('l1', b.text) - 4)), convert(int, substring(b.text, charindex('l2', b.text) + 3, charindex('l3', b.text) - charindex('l2', b.text) - 4)), convert(int, substring(b.text, charindex('l3', b.text) + 3, charindex('p1', b.text) - charindex('l3', b.text) - 4)), convert(int, substring(b.text, charindex('p1', b.text) + 3, charindex('p2', b.text) - charindex('p1', b.text) - 4)), convert(int, substring(b.text, charindex('p2', b.text) + 3, charindex('p3', b.text) - charindex('p2', b.text) - 4)), convert(int, substring(b.text, charindex('p3', b.text) + 3, charindex('c', b.text) - charindex('p3', b.text) - 4)), convert(int, substring(b.text, charindex('c', b.text) + 2, charindex('ac', b.text) - charindex('c', b.text) - 3)), convert(int, substring(b.text, charindex('ac', b.text) + 3, char_length(b.text) - charindex('ac', b.text) - 2)), a.text from sysqueryplans a, sysqueryplans b where (a.type = 10) and (b.type =1000) and (a.id = b.id) and a.uid = b.uid and a.gid = b.gid
go
IF OBJECT_ID('dbo.sysquerymetrics') IS NOT NULL
    PRINT '<<< CREATED VIEW dbo.sysquerymetrics >>>'
ELSE
    PRINT '<<< FAILED CREATING VIEW dbo.sysquerymetrics >>>'
go

IF OBJECT_ID('dbo.v_PrimaryDB') IS NOT NULL
BEGIN
    DROP VIEW dbo.v_PrimaryDB
    IF OBJECT_ID('dbo.v_PrimaryDB') IS NOT NULL
        PRINT '<<< FAILED DROPPING VIEW dbo.v_PrimaryDB >>>'
    ELSE
        PRINT '<<< DROPPED VIEW dbo.v_PrimaryDB >>>'
END
go
CREATE VIEW v_PrimaryDB 
AS
SELECT 
    primaryDBId, 
    primaryDBName, 
    primarySRVName,
    maintUserName,
    maintUserPass
FROM  PrimaryDB 
WHERE primaryFlag = 'Y'
go
IF OBJECT_ID('dbo.v_PrimaryDB') IS NOT NULL
    PRINT '<<< CREATED VIEW dbo.v_PrimaryDB >>>'
ELSE
    PRINT '<<< FAILED CREATING VIEW dbo.v_PrimaryDB >>>'
go

IF OBJECT_ID('dbo.v_RepLatencyLog') IS NOT NULL
BEGIN
    DROP VIEW dbo.v_RepLatencyLog
    IF OBJECT_ID('dbo.v_RepLatencyLog') IS NOT NULL
        PRINT '<<< FAILED DROPPING VIEW dbo.v_RepLatencyLog >>>'
    ELSE
        PRINT '<<< DROPPED VIEW dbo.v_RepLatencyLog >>>'
END
go
CREATE VIEW v_RepLatencyLog
AS
SELECT d.replicateSRVName,
       d.replicateDBName,
       r.latencyInSec,
       r.dateCreatedPrimary
FROM RepLatencyLog r, ReplicateDB d
WHERE r.replicateDBId = d.replicateDBId
  AND r.dateCreatedPrimary >= dateadd(dd, -1, getdate())
go
IF OBJECT_ID('dbo.v_RepLatencyLog') IS NOT NULL
    PRINT '<<< CREATED VIEW dbo.v_RepLatencyLog >>>'
ELSE
    PRINT '<<< FAILED CREATING VIEW dbo.v_RepLatencyLog >>>'
go

IF OBJECT_ID('dbo.v_RepLatencyLog30') IS NOT NULL
BEGIN
    DROP VIEW dbo.v_RepLatencyLog30
    IF OBJECT_ID('dbo.v_RepLatencyLog30') IS NOT NULL
        PRINT '<<< FAILED DROPPING VIEW dbo.v_RepLatencyLog30 >>>'
    ELSE
        PRINT '<<< DROPPED VIEW dbo.v_RepLatencyLog30 >>>'
END
go
CREATE VIEW v_RepLatencyLog30
AS
SELECT d.replicateSRVName,
       d.replicateDBName,
       r.latencyInSec,
       r.dateCreatedPrimary
FROM RepLatencyLog r, ReplicateDB d
WHERE r.replicateDBId = d.replicateDBId
  AND r.dateCreatedPrimary >= dateadd(dd, -1, getdate())
  AND r.latencyInSec > 30
go
IF OBJECT_ID('dbo.v_RepLatencyLog30') IS NOT NULL
    PRINT '<<< CREATED VIEW dbo.v_RepLatencyLog30 >>>'
ELSE
    PRINT '<<< FAILED CREATING VIEW dbo.v_RepLatencyLog30 >>>'
go

IF OBJECT_ID('dbo.v_ReplicateDB') IS NOT NULL
BEGIN
    DROP VIEW dbo.v_ReplicateDB
    IF OBJECT_ID('dbo.v_ReplicateDB') IS NOT NULL
        PRINT '<<< FAILED DROPPING VIEW dbo.v_ReplicateDB >>>'
    ELSE
        PRINT '<<< DROPPED VIEW dbo.v_ReplicateDB >>>'
END
go
CREATE VIEW v_ReplicateDB 
AS
SELECT 
    replicateDBId, 
    replicateDBName, 
    replicateSRVName,
    primarySRVName
FROM  ReplicateDB 
WHERE replicateFlag = 'Y'
go
IF OBJECT_ID('dbo.v_ReplicateDB') IS NOT NULL
    PRINT '<<< CREATED VIEW dbo.v_ReplicateDB >>>'
ELSE
    PRINT '<<< FAILED CREATING VIEW dbo.v_ReplicateDB >>>'
go

--=================
-- DATA
--=================

--
-- TABLE INSERT STATEMENTS
--
INSERT INTO dbo.PrimaryDB ( primaryDBId, primaryDBName, primarySRVName, primaryFlag, maintUserName, maintUserPass ) 
		 VALUES ( 4, 'nycLL', 'v151dbp03ivr', 'Y', 'x2kmaint', '[PASSWORD]' ) 
go
INSERT INTO dbo.PrimaryDB ( primaryDBId, primaryDBName, primarySRVName, primaryFlag, maintUserName, maintUserPass ) 
		 VALUES ( 5, 'torLL', 'v151dbp03ivr', 'Y', 'x2kmaint', '[PASSWORD]' ) 
go
INSERT INTO dbo.PrimaryDB ( primaryDBId, primaryDBName, primarySRVName, primaryFlag, maintUserName, maintUserPass ) 
		 VALUES ( 3, 'Profile_ai', 'w151dbp03', 'Y', 'webmaint', [PASSWORD]' ) 
go
INSERT INTO dbo.PrimaryDB ( primaryDBId, primaryDBName, primarySRVName, primaryFlag, maintUserName, maintUserPass ) 
		 VALUES ( 2, 'Profile_ar', 'w151dbp03', 'Y', 'webmaint', [PASSWORD]' ) 
go
INSERT INTO dbo.PrimaryDB ( primaryDBId, primaryDBName, primarySRVName, primaryFlag, maintUserName, maintUserPass ) 
		 VALUES ( 1, 'Profile_ad', 'w151dbp03', 'Y', 'webmaint', [PASSWORD]' ) 
go

--
-- TABLE INSERT STATEMENTS
--
INSERT INTO dbo.ReplicateDB ( replicateDBId, replicateDBName, replicateSRVName, replicateFlag, primarySRVName ) 
		 VALUES ( 101, 'Profile_ad', 'w151dbr01', 'Y', 'w151dbp03' ) 
go
INSERT INTO dbo.ReplicateDB ( replicateDBId, replicateDBName, replicateSRVName, replicateFlag, primarySRVName ) 
		 VALUES ( 102, 'Profile_ar', 'w151dbr01', 'Y', 'w151dbp03' ) 
go
INSERT INTO dbo.ReplicateDB ( replicateDBId, replicateDBName, replicateSRVName, replicateFlag, primarySRVName ) 
		 VALUES ( 103, 'Profile_ai', 'w151dbr01', 'Y', 'w151dbp03' ) 
go
INSERT INTO dbo.ReplicateDB ( replicateDBId, replicateDBName, replicateSRVName, replicateFlag, primarySRVName ) 
		 VALUES ( 104, 'Profile_ad', 'w151dbr02', 'Y', 'w151dbp03' ) 
go
INSERT INTO dbo.ReplicateDB ( replicateDBId, replicateDBName, replicateSRVName, replicateFlag, primarySRVName ) 
		 VALUES ( 105, 'Profile_ar', 'w151dbr02', 'Y', 'w151dbp03' ) 
go
INSERT INTO dbo.ReplicateDB ( replicateDBId, replicateDBName, replicateSRVName, replicateFlag, primarySRVName ) 
		 VALUES ( 106, 'Profile_ai', 'w151dbr02', 'Y', 'w151dbp03' ) 
go
INSERT INTO dbo.ReplicateDB ( replicateDBId, replicateDBName, replicateSRVName, replicateFlag, primarySRVName ) 
		 VALUES ( 107, 'Profile_ar', 'w151dbr03', 'Y', 'w151dbp03' ) 
go
INSERT INTO dbo.ReplicateDB ( replicateDBId, replicateDBName, replicateSRVName, replicateFlag, primarySRVName ) 
		 VALUES ( 108, 'Profile_ad', 'w151dbr03', 'Y', 'w151dbp03' ) 
go
INSERT INTO dbo.ReplicateDB ( replicateDBId, replicateDBName, replicateSRVName, replicateFlag, primarySRVName ) 
		 VALUES ( 109, 'Profile_ai', 'w151dbr03', 'Y', 'w151dbp03' ) 
go

--
-- TABLE INSERT STATEMENTS
--
INSERT INTO dbo.ReplicateDB_SRV ( serverId, serverName ) 	 VALUES ( 1, 'w151dbr01' ) 
INSERT INTO dbo.ReplicateDB_SRV ( serverId, serverName )     VALUES ( 2, 'w151dbr02' ) 
INSERT INTO dbo.ReplicateDB_SRV ( serverId, serverName ) 	 VALUES ( 3, 'w151dbr03' ) 
go

INSERT INTO dbo.ReplicationServer ( repServerId, repServerName, rssdServerName, rssdName, stableQueuePrefix ) 
		 VALUES ( 1, 'w151rep01', 'w151rssd01', 'rep01_RSSD', 'w151rep01_SD' ) 
go
