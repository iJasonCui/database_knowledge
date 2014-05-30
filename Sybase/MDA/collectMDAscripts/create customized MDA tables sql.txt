CREATE TABLE dbo.ServerBoot
(
    serverBootTime datetime NOT NULL
)
LOCK ALLPAGES
go
IF OBJECT_ID('dbo.ServerBoot') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.ServerBoot >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.ServerBoot >>>'
go

CREATE TABLE dbo.monDeadLock
(
    serverName        varchar(30)  NOT NULL,
    dateCreated       datetime     NOT NULL,
    DeadlockID        int          NOT NULL,
    VictimKPID        int          NOT NULL,
    ResolveTime       datetime     NOT NULL,
    ObjectDBID        int          NOT NULL,
    objectDBName      varchar(30)  NOT NULL,
    PageNumber        int          NOT NULL,
    RowNumber         int          NOT NULL,
    HeldFamilyID      smallint     NOT NULL,
    HeldSPID          smallint     NOT NULL,
    HeldKPID          int          NOT NULL,
    HeldProcDBID      int          NOT NULL,
    heldProcDBName    varchar(30)  NOT NULL,
    HeldProcedureID   int          NOT NULL,
    heldProcedureName varchar(30)  NOT NULL,
    HeldBatchID       int          NOT NULL,
    HeldContextID     int          NOT NULL,
    HeldLineNumber    int          NOT NULL,
    WaitFamilyID      smallint     NOT NULL,
    WaitSPID          smallint     NOT NULL,
    WaitKPID          int          NOT NULL,
    WaitTime          int          NOT NULL,
    ObjectName        varchar(30)  NULL,
    HeldUserName      varchar(30)  NULL,
    HeldApplName      varchar(30)  NULL,
    HeldTranName      varchar(255) NULL,
    HeldLockType      varchar(20)  NULL,
    HeldCommand       varchar(30)  NULL,
    WaitUserName      varchar(30)  NULL,
    WaitLockType      varchar(20)  NULL
)
LOCK ALLPAGES
go
GRANT SELECT ON dbo.monDeadLock TO mon_role
go
IF OBJECT_ID('dbo.monDeadLock') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.monDeadLock >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.monDeadLock >>>'
go

CREATE TABLE dbo.monDeadLockPlot
(
    serverName  varchar(30) NOT NULL,
    dateCreated datetime    NOT NULL,
    noDeadlocks int         NOT NULL
)
LOCK ALLPAGES
go
IF OBJECT_ID('dbo.monDeadLockPlot') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.monDeadLockPlot >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.monDeadLockPlot >>>'
go

CREATE TABLE dbo.monEngine
(
    serverName          varchar(30) NOT NULL,
    dateCreated         datetime    NOT NULL,
    EngineNumber        smallint    NOT NULL,
    CurrentKPID         int         NOT NULL,
    PreviousKPID        int         NOT NULL,
    CPUTime             int         NOT NULL,
    SystemCPUTime       int         NOT NULL,
    UserCPUTime         int         NOT NULL,
    IdleCPUTime         int         NOT NULL,
    Yields              int         NOT NULL,
    Connections         int         NOT NULL,
    DiskIOChecks        int         NOT NULL,
    DiskIOPolled        int         NOT NULL,
    DiskIOCompleted     int         NOT NULL,
    ProcessesAffinitied int         NOT NULL,
    ContextSwitches     int         NOT NULL,
    Status              varchar(20) NULL,
    StartTime           datetime    NULL,
    StopTime            datetime    NULL,
    AffinitiedToCPU     int         NULL,
    OSPID               int         NULL
)
LOCK ALLPAGES
go
GRANT SELECT ON dbo.monEngine TO mon_role
go
IF OBJECT_ID('dbo.monEngine') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.monEngine >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.monEngine >>>'
go

CREATE TABLE dbo.monEnginePlot
(
    serverName   varchar(30)  NULL,
    dateCreated  datetime     NULL,
    EngineNumber smallint     NOT NULL,
    Utilisation  numeric(5,2) NOT NULL
)
LOCK ALLPAGES
go
IF OBJECT_ID('dbo.monEnginePlot') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.monEnginePlot >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.monEnginePlot >>>'
go

CREATE TABLE dbo.monNetworkIO
(
    serverName      varchar(30) NOT NULL,
    dateCreated     datetime    NOT NULL,
    PacketsSent     int         NOT NULL,
    PacketsReceived int         NOT NULL,
    BytesSent       int         NOT NULL,
    BytesReceived   int         NOT NULL
)
LOCK ALLPAGES
go
GRANT SELECT ON dbo.monNetworkIO TO mon_role
go
IF OBJECT_ID('dbo.monNetworkIO') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.monNetworkIO >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.monNetworkIO >>>'
go

CREATE TABLE dbo.monNetworkIOPlot
(
    serverName      varchar(30) NULL,
    dateCreated     datetime    NULL,
    PacketsSent     int         NOT NULL,
    PacketsReceived int         NOT NULL,
    BytesSent       int         NOT NULL,
    BytesReceived   int         NOT NULL
)
LOCK ALLPAGES
go
IF OBJECT_ID('dbo.monNetworkIOPlot') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.monNetworkIOPlot >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.monNetworkIOPlot >>>'
go

CREATE TABLE dbo.monOpenObjectActivity
(
    serverName        varchar(30) NOT NULL,
    dateCreated       datetime    NOT NULL,
    DBID              int         NOT NULL,
    databaseName      varchar(30) NOT NULL,
    ObjectID          int         NOT NULL,
    objectName        varchar(30) NOT NULL,
    IndexID           int         NOT NULL,
    LogicalReads      int         NOT NULL,
    PhysicalReads     int         NOT NULL,
    APFReads          int         NOT NULL,
    PagesRead         int         NOT NULL,
    PhysicalWrites    int         NOT NULL,
    PagesWritten      int         NOT NULL,
    OptSelectCount    int         NOT NULL,
    UsedCount         int         NOT NULL,
    RowsInserted      int         NULL,
    RowsDeleted       int         NULL,
    RowsUpdated       int         NULL,
    Operations        int         NULL,
    LockRequests      int         NULL,
    LockWaits         int         NULL,
    LastOptSelectDate datetime    NULL,
    LastUsedDate      datetime    NULL
)
LOCK ALLPAGES
go
GRANT SELECT ON dbo.monOpenObjectActivity TO mon_role
go
IF OBJECT_ID('dbo.monOpenObjectActivity') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.monOpenObjectActivity >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.monOpenObjectActivity >>>'
go

CREATE TABLE dbo.monProcessActivity
(
    serverName      varchar(30) NOT NULL,
    dateCreated     datetime    NOT NULL,
    SPID            smallint    NOT NULL,
    KPID            int         NOT NULL,
    ServerUserID    int         NOT NULL,
    serverUserName  varchar(30) NOT NULL,
    CPUTime         int         NOT NULL,
    WaitTime        int         NOT NULL,
    PhysicalReads   int         NOT NULL,
    LogicalReads    int         NOT NULL,
    PagesRead       int         NOT NULL,
    PhysicalWrites  int         NOT NULL,
    PagesWritten    int         NOT NULL,
    MemUsageKB      int         NOT NULL,
    LocksHeld       int         NOT NULL,
    TableAccesses   int         NOT NULL,
    IndexAccesses   int         NOT NULL,
    TempDbObjects   int         NOT NULL,
    WorkTables      int         NOT NULL,
    ULCBytesWritten int         NOT NULL,
    ULCFlushes      int         NOT NULL,
    ULCFlushFull    int         NOT NULL,
    ULCMaxUsage     int         NOT NULL,
    ULCCurrentUsage int         NOT NULL,
    Transactions    int         NOT NULL,
    Commits         int         NOT NULL,
    Rollbacks       int         NOT NULL,
    Login           varchar(30) NULL
)
LOCK ALLPAGES
go
GRANT SELECT ON dbo.monProcessActivity TO mon_role
go
IF OBJECT_ID('dbo.monProcessActivity') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.monProcessActivity >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.monProcessActivity >>>'
go

CREATE TABLE dbo.monProcessActivityPlot
(
    serverName   varchar(30) NULL,
    dateCreated  datetime    NULL,
    Transactions int         NOT NULL,
    Commits      int         NOT NULL,
    Rollbacks    int         NOT NULL,
    Login        varchar(30) NULL
)
LOCK ALLPAGES
go
IF OBJECT_ID('dbo.monProcessActivityPlot') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.monProcessActivityPlot >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.monProcessActivityPlot >>>'
go

CREATE TABLE dbo.monSysSQLText
(
    serverName      varchar(30)  NOT NULL,
    dateCreated     datetime     NOT NULL,
    SPID            smallint     NOT NULL,
    KPID            int          NOT NULL,
    ServerUserID    int          NOT NULL,
    serverUserName  varchar(30)  NOT NULL,
    BatchID         int          NOT NULL,
    SequenceInBatch int          NOT NULL,
    SQLText         varchar(255) NULL
)
LOCK ALLPAGES
go
GRANT SELECT ON dbo.monSysSQLText TO mon_role
go
IF OBJECT_ID('dbo.monSysSQLText') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.monSysSQLText >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.monSysSQLText >>>'
go

CREATE TABLE dbo.monSysStatement
(
    serverName        varchar(30) NOT NULL,
    dateCreated       datetime    NOT NULL,
    SPID              smallint    NOT NULL,
    KPID              int         NOT NULL,
    DBID              int         NOT NULL,
    ProcedureID       int         NOT NULL,
    procedureName     varchar(30) NOT NULL,
    PlanID            int         NOT NULL,
    BatchID           int         NOT NULL,
    ContextID         int         NOT NULL,
    LineNumber        int         NOT NULL,
    CpuTime           int         NOT NULL,
    WaitTime          int         NOT NULL,
    MemUsageKB        int         NOT NULL,
    PhysicalReads     int         NOT NULL,
    LogicalReads      int         NOT NULL,
    PagesModified     int         NOT NULL,
    PacketsSent       int         NOT NULL,
    PacketsReceived   int         NOT NULL,
    NetworkPacketSize int         NOT NULL,
    PlansAltered      int         NOT NULL,
    StartTime         datetime    NULL,
    EndTime           datetime    NULL
)
LOCK ALLPAGES
go
GRANT SELECT ON dbo.monSysStatement TO mon_role
go
IF OBJECT_ID('dbo.monSysStatement') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.monSysStatement >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.monSysStatement >>>'
go

CREATE TABLE dbo.mon_db_control_tab
(
    name   varchar(15) NOT NULL,
    status varchar(15) NOT NULL,
    spid   int         NOT NULL,
    dt     datetime    NOT NULL
)
LOCK ALLPAGES
go
IF OBJECT_ID('dbo.mon_db_control_tab') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.mon_db_control_tab >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.mon_db_control_tab >>>'
go

CREATE TABLE dbo.object_stats
(
    serverName        varchar(30) NOT NULL,
    dateCreated       datetime    NOT NULL,
    DBID              int         NOT NULL,
    databaseName      varchar(30) NOT NULL,
    ObjectID          int         NOT NULL,
    objectName        varchar(30) NOT NULL,
    IndexID           int         NOT NULL,
    LogicalReads      int         NOT NULL,
    PhysicalReads     int         NOT NULL,
    APFReads          int         NOT NULL,
    PagesRead         int         NOT NULL,
    PhysicalWrites    int         NOT NULL,
    PagesWritten      int         NOT NULL,
    OptSelectCount    int         NOT NULL,
    UsedCount         int         NOT NULL,
    RowsInserted      int         NULL,
    RowsDeleted       int         NULL,
    RowsUpdated       int         NULL,
    Operations        int         NULL,
    LockRequests      int         NULL,
    LockWaits         int         NULL,
    LastOptSelectDate datetime    NULL,
    LastUsedDate      datetime    NULL
)
LOCK ALLPAGES
go
GRANT SELECT ON dbo.object_stats TO mon_role
go
IF OBJECT_ID('dbo.object_stats') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.object_stats >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.object_stats >>>'
go

CREATE TABLE dbo.proc_stats
(
    SRVName       varchar(30)   NOT NULL,
    ProcName      varchar(30)   NOT NULL,
    DBName        varchar(30)   NOT NULL,
    SPID          smallint      NOT NULL,
    DBID          int           NOT NULL,
    ProcedureID   int           NOT NULL,
    BatchID       int           NOT NULL,
    CpuTime       numeric(15,0) NOT NULL,
    WaitTime      numeric(15,0) NOT NULL,
    PhysicalReads numeric(15,0) NOT NULL,
    LogicalReads  numeric(15,0) NOT NULL,
    PacketsSent   numeric(15,0) NOT NULL,
    StartTime     datetime      NOT NULL,
    EndTime       datetime      NOT NULL,
    ElapsedTime   numeric(15,0) NOT NULL,
    dateCreated   datetime      NULL,
    NumExecs      int           NULL
)
LOCK ALLPAGES
go
IF OBJECT_ID('dbo.proc_stats') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.proc_stats >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.proc_stats >>>'
go
