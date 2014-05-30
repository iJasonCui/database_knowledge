CREATE TABLE dbo.Alert
(
    alertId         int          NOT NULL,
    alertNotes      varchar(255) NULL,
    createdBy       int          NOT NULL,
    dateCreated     datetime     NOT NULL,
    jobId           int          NOT NULL,
    alertLevel      int          DEFAULT 0 NOT NULL,
    executionId     int          NULL,
    nagiosIndicator char(1)      NULL,
    scheduleId      int          NULL,
    CONSTRAINT PK_ALERT
    PRIMARY KEY CLUSTERED (alertId)
)
LOCK ALLPAGES
go
GRANT SELECT ON dbo.Alert TO backmon
go
IF OBJECT_ID('dbo.Alert') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.Alert >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.Alert >>>'
go
CREATE NONCLUSTERED INDEX dte
    ON dbo.Alert(dateCreated)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.Alert') AND name='dte')
    PRINT '<<< CREATED INDEX dbo.Alert.dte >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.Alert.dte >>>'
go
CREATE NONCLUSTERED INDEX sched
    ON dbo.Alert(scheduleId)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.Alert') AND name='sched')
    PRINT '<<< CREATED INDEX dbo.Alert.sched >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.Alert.sched >>>'
go
CREATE NONCLUSTERED INDEX Alert_jobId
    ON dbo.Alert(jobId)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.Alert') AND name='Alert_jobId')
    PRINT '<<< CREATED INDEX dbo.Alert.Alert_jobId >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.Alert.Alert_jobId >>>'
go
CREATE NONCLUSTERED INDEX Alert_executionId
    ON dbo.Alert(executionId)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.Alert') AND name='Alert_executionId')
    PRINT '<<< CREATED INDEX dbo.Alert.Alert_executionId >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.Alert.Alert_executionId >>>'
go

CREATE TABLE dbo.AlertId
(
    alertId int NOT NULL
)
LOCK ALLPAGES
go
GRANT SELECT ON dbo.AlertId TO backmon
go
IF OBJECT_ID('dbo.AlertId') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.AlertId >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.AlertId >>>'
go

CREATE TABLE dbo.AlertMonitor
(
    dateLastRun datetime NOT NULL
)
LOCK ALLPAGES
go
GRANT SELECT ON dbo.AlertMonitor TO backmon
go
IF OBJECT_ID('dbo.AlertMonitor') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.AlertMonitor >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.AlertMonitor >>>'
go

CREATE TABLE dbo.AlertTemp
(
    alertId         int          NOT NULL,
    alertNotes      varchar(255) NULL,
    createdBy       int          NOT NULL,
    dateCreated     datetime     NOT NULL,
    jobId           int          NOT NULL,
    alertLevel      int          DEFAULT 0 NOT NULL,
    executionId     int          NULL,
    nagiosIndicator char(1)      NULL,
    scheduleId      int          NULL
)
LOCK ALLPAGES
go
GRANT SELECT ON dbo.AlertTemp TO backmon
go
IF OBJECT_ID('dbo.AlertTemp') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.AlertTemp >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.AlertTemp >>>'
go

CREATE TABLE dbo.Email
(
    emailId         int           NOT NULL,
    emailName       varchar(20)   NOT NULL,
    emailDesc       varchar(40)   NOT NULL,
    createdBy       int           NOT NULL,
    dateCreated     datetime      NOT NULL,
    modifiedBy      int           NOT NULL,
    dateModified    datetime      NOT NULL,
    activeStatusInd char(1)       DEFAULT "Y" NOT NULL,
    ownerGroup      int           NULL,
    eString         varchar(1000) NULL,
    CONSTRAINT Email_18762017341
    PRIMARY KEY CLUSTERED (emailId)
)
LOCK ALLPAGES
go
GRANT SELECT ON dbo.Email TO backmon
go
IF OBJECT_ID('dbo.Email') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.Email >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.Email >>>'
go

CREATE TABLE dbo.EmailCheck
(
    jobId       int      NOT NULL,
    dateCreated datetime NOT NULL,
    emailCondId int      NOT NULL,
    executionId int      NULL,
    processInd  bit      NOT NULL,
    CONSTRAINT EmailCheck_19207258952
    PRIMARY KEY NONCLUSTERED (jobId,dateCreated)
)
LOCK ALLPAGES
go
GRANT SELECT ON dbo.EmailCheck TO backmon
go
IF OBJECT_ID('dbo.EmailCheck') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.EmailCheck >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.EmailCheck >>>'
go

CREATE TABLE dbo.EmailCondition
(
    emailCondId     int         NOT NULL,
    condition       varchar(20) NOT NULL,
    condDescription varchar(40) NULL,
    CONSTRAINT EmailCondi_19242019051
    PRIMARY KEY CLUSTERED (emailCondId)
)
LOCK ALLPAGES
go
GRANT SELECT ON dbo.EmailCondition TO backmon
go
IF OBJECT_ID('dbo.EmailCondition') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.EmailCondition >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.EmailCondition >>>'
go

CREATE TABLE dbo.EmailId
(
    EmailId int NOT NULL
)
LOCK ALLPAGES
go
GRANT SELECT ON dbo.EmailId TO backmon
go
IF OBJECT_ID('dbo.EmailId') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.EmailId >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.EmailId >>>'
go

CREATE TABLE dbo.ExecutionHistory
(
    executionId     int          NOT NULL,
    scheduleId      int          NULL,
    createdBy       int          NOT NULL,
    dateCreated     datetime     NOT NULL,
    executionNote   varchar(255) NULL,
    logLocation     varchar(100) NULL,
    executionStatus int          NOT NULL,
    jobSpecificCode int          NULL,
    jobId           int          NOT NULL,
    CONSTRAINT ExecutionH_16842010501
    PRIMARY KEY CLUSTERED (executionId)
)
LOCK ALLPAGES
go
GRANT SELECT ON dbo.ExecutionHistory TO backmon
go
IF OBJECT_ID('dbo.ExecutionHistory') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.ExecutionHistory >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.ExecutionHistory >>>'
go

CREATE TABLE dbo.ExecutionId
(
    executionId int NOT NULL
)
LOCK ALLPAGES
go
GRANT SELECT ON dbo.ExecutionId TO backmon
go
IF OBJECT_ID('dbo.ExecutionId') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.ExecutionId >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.ExecutionId >>>'
go

CREATE TABLE dbo.ExecutionStatus
(
    executionStatus     int         NOT NULL,
    executionStatusName varchar(10) NOT NULL,
    executionStatusDesc varchar(40) NOT NULL,
    dateCreated         datetime    NOT NULL,
    CONSTRAINT PK_EXECUTIONSTATUS
    PRIMARY KEY CLUSTERED (executionStatus)
)
LOCK ALLPAGES
go
GRANT SELECT ON dbo.ExecutionStatus TO backmon
go
IF OBJECT_ID('dbo.ExecutionStatus') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.ExecutionStatus >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.ExecutionStatus >>>'
go

CREATE TABLE dbo.FailedExecution
(
    executionId     int          NOT NULL,
    scheduleId      int          NULL,
    createdBy       int          NOT NULL,
    dateCreated     datetime     NOT NULL,
    executionNote   varchar(255) NULL,
    logLocation     varchar(100) NULL,
    executionStatus int          NOT NULL,
    jobSpecificCode int          NULL,
    jobId           int          NOT NULL,
    failError       int          NOT NULL,
    CONSTRAINT FailedExec_11290550582
    PRIMARY KEY NONCLUSTERED (executionId)
)
LOCK ALLPAGES
go
GRANT SELECT ON dbo.FailedExecution TO backmon
go
IF OBJECT_ID('dbo.FailedExecution') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.FailedExecution >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.FailedExecution >>>'
go

CREATE TABLE dbo.GroupId
(
    groupId int NOT NULL
)
LOCK ALLPAGES
go
GRANT SELECT ON dbo.GroupId TO backmon
go
IF OBJECT_ID('dbo.GroupId') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.GroupId >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.GroupId >>>'
go

CREATE TABLE dbo.Groups
(
    groupId         int      NOT NULL,
    gid             smallint NOT NULL,
    dateCreated     datetime NOT NULL,
    createBy        int      NOT NULL,
    activeStatusInd char(1)  NOT NULL,
    dateModified    datetime NOT NULL,
    modifiedBy      int      NOT NULL,
    CONSTRAINT PK_GROUPID
    PRIMARY KEY CLUSTERED (groupId)
)
LOCK ALLPAGES
go
GRANT SELECT ON dbo.Groups TO backmon
go
IF OBJECT_ID('dbo.Groups') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.Groups >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.Groups >>>'
go
CREATE UNIQUE NONCLUSTERED INDEX AKgroups
    ON dbo.Groups(gid)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.Groups') AND name='AKgroups')
    PRINT '<<< CREATED INDEX dbo.Groups.AKgroups >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.Groups.AKgroups >>>'
go

CREATE TABLE dbo.Host
(
    hostId       int         NOT NULL,
    hostName     varchar(20) NOT NULL,
    hostDesc     varchar(40) NOT NULL,
    createdBy    int         NOT NULL,
    dateCreated  datetime    NOT NULL,
    modifiedBy   int         NOT NULL,
    dateModified datetime    NOT NULL,
    CONSTRAINT Host_14956763761
    PRIMARY KEY CLUSTERED (hostId)
)
LOCK ALLPAGES
go
GRANT SELECT ON dbo.Host TO backmon
go
IF OBJECT_ID('dbo.Host') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.Host >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.Host >>>'
go
CREATE UNIQUE NONCLUSTERED INDEX Host_AK
    ON dbo.Host(hostName)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.Host') AND name='Host_AK')
    PRINT '<<< CREATED INDEX dbo.Host.Host_AK >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.Host.Host_AK >>>'
go
CREATE TRIGGER dbo.abc
ON dbo.Host
FOR INSERT AS
if exists (select 1 from Host H,inserted I where lower(H.hostName)=
lower(I.hostName) )
begin 
print  "ABS TEST"
rollback tran
return
end
go
ALTER TABLE dbo.Host DISABLE TRIGGER dbo.abc
go
IF OBJECT_ID('dbo.abc') IS NOT NULL
    PRINT '<<< CREATED TRIGGER dbo.abc >>>'
ELSE
    PRINT '<<< FAILED CREATING TRIGGER dbo.abc >>>'
go

CREATE TABLE dbo.HostId
(
    hostId int NOT NULL
)
LOCK ALLPAGES
go
GRANT SELECT ON dbo.HostId TO backmon
go
IF OBJECT_ID('dbo.HostId') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.HostId >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.HostId >>>'
go

CREATE TABLE dbo.JobHist
(
    jobId            int         NOT NULL,
    dateUpdated      datetime    NOT NULL,
    updatedBy        int         NOT NULL,
    jobTypeId        int         NOT NULL,
    jobName          varchar(10) NOT NULL,
    jobDesc          varchar(40) NOT NULL,
    createdBy        int         NOT NULL,
    dateCreated      datetime    NOT NULL,
    modifiedBy       int         NOT NULL,
    dateModified     datetime    NOT NULL,
    scriptname       varchar(30) NOT NULL,
    activeStatusInd  char(1)     DEFAULT "Y" NOT NULL,
    expectedDuration int         NOT NULL,
    delayBeforeAlarm int         NOT NULL,
    ownerGroup       int         NULL,
    scriptPath       varchar(40) NULL,
    hostId           int         NULL,
    emailId          int         NULL,
    emailCondId      int         NULL,
    nagId            int         NULL,
    CONSTRAINT PK_JOBHIST
    PRIMARY KEY CLUSTERED (jobId,dateUpdated)
)
LOCK ALLPAGES
go
GRANT SELECT ON dbo.JobHist TO backmon
go
IF OBJECT_ID('dbo.JobHist') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.JobHist >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.JobHist >>>'
go

CREATE TABLE dbo.JobId
(
    jobId int NOT NULL
)
LOCK ALLPAGES
go
GRANT SELECT ON dbo.JobId TO backmon
go
IF OBJECT_ID('dbo.JobId') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.JobId >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.JobId >>>'
go

CREATE TABLE dbo.JobSpecificCode
(
    jobSpecificCode     int         NOT NULL,
    jobSpecificCodeName varchar(10) NOT NULL,
    jobSpecificCodeDesc varchar(40) NOT NULL,
    dateCreated         datetime    NOT NULL,
    CONSTRAINT PK_JOBSPECIFICCODE
    PRIMARY KEY CLUSTERED (jobSpecificCode)
)
LOCK ALLPAGES
go
GRANT SELECT ON dbo.JobSpecificCode TO backmon
go
IF OBJECT_ID('dbo.JobSpecificCode') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.JobSpecificCode >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.JobSpecificCode >>>'
go

CREATE TABLE dbo.JobType
(
    jobTypeId   int         NOT NULL,
    jobTypeName varchar(10) NOT NULL,
    jobTypeDesc varchar(40) NOT NULL,
    dateCreated datetime    NOT NULL,
    CONSTRAINT PK_JOBTYPE
    PRIMARY KEY CLUSTERED (jobTypeId)
)
LOCK ALLPAGES
go
GRANT SELECT ON dbo.JobType TO backmon
go
IF OBJECT_ID('dbo.JobType') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.JobType >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.JobType >>>'
go

CREATE TABLE dbo.NAGIOSServices
(
    nagId       int         NOT NULL,
    nagName     varchar(40) NOT NULL,
    nagDesc     varchar(40) NOT NULL,
    createdBy   int         NOT NULL,
    dateCreated datetime    NOT NULL,
    emailString varchar(40) NOT NULL,
    nagString   varchar(20) NULL,
    rtId        int         NULL,
    rtOwnerId   int         NULL,
    CONSTRAINT NAGIOSServ_19562020191
    PRIMARY KEY CLUSTERED (nagId)
)
LOCK ALLPAGES
go
GRANT SELECT ON dbo.NAGIOSServices TO backmon
go
IF OBJECT_ID('dbo.NAGIOSServices') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.NAGIOSServices >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.NAGIOSServices >>>'
go

CREATE TABLE dbo.RepTest
(
    repTestId       int      NOT NULL,
    dateTime        datetime NOT NULL,
    defaultDateTime datetime DEFAULT GETDATE() NULL
)
LOCK ALLPAGES
go
IF OBJECT_ID('dbo.RepTest') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.RepTest >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.RepTest >>>'
go

CREATE TABLE dbo.Schedule
(
    scheduleId       int         NOT NULL,
    jobId            int         NOT NULL,
    scheduleName     varchar(10) NOT NULL,
    scheduleDesc     varchar(40) NOT NULL,
    createdBy        int         NOT NULL,
    dateCreated      datetime    NOT NULL,
    modifiedBy       int         NOT NULL,
    dateModified     datetime    NOT NULL,
    cronMin1         int         DEFAULT -1 NOT NULL,
    cronMin2         int         DEFAULT -1 NOT NULL,
    cronMin3         int         DEFAULT -1 NOT NULL,
    cronMin4         int         DEFAULT -1 NOT NULL,
    cronHr1          int         DEFAULT -1 NOT NULL,
    cronHr2          int         DEFAULT -1 NOT NULL,
    cronHr3          int         DEFAULT -1 NOT NULL,
    cronHr4          int         DEFAULT -1 NOT NULL,
    cronSun          bit         DEFAULT 0 NOT NULL,
    cronMon          bit         DEFAULT 0 NOT NULL,
    cronTue          bit         DEFAULT 0 NOT NULL,
    cronWed          bit         DEFAULT 0 NOT NULL,
    cronThu          bit         DEFAULT 0 NOT NULL,
    cronFri          bit         DEFAULT 0 NOT NULL,
    cronSat          bit         DEFAULT 0 NOT NULL,
    cronMonth        int         DEFAULT -1 NOT NULL,
    effectiveFrom    datetime    NOT NULL,
    effectiveTo      datetime    NOT NULL,
    activeStatusInd  char(1)     DEFAULT 'Y' NOT NULL,
    expectedDuration int         NOT NULL,
    delayBeforeAlarm int         NOT NULL,
    scheduleApp      varchar(30) NOT NULL,
    alertLevel       int         NOT NULL,
    CONSTRAINT PK_SCHEDULE
    PRIMARY KEY CLUSTERED (scheduleId)
)
LOCK ALLPAGES
go
GRANT SELECT ON dbo.Schedule TO backmon
go
IF OBJECT_ID('dbo.Schedule') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.Schedule >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.Schedule >>>'
go
CREATE NONCLUSTERED INDEX JOB
    ON dbo.Schedule(jobId)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.Schedule') AND name='JOB')
    PRINT '<<< CREATED INDEX dbo.Schedule.JOB >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.Schedule.JOB >>>'
go
CREATE NONCLUSTERED INDEX sced_dte
    ON dbo.Schedule(dateCreated)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.Schedule') AND name='sced_dte')
    PRINT '<<< CREATED INDEX dbo.Schedule.sced_dte >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.Schedule.sced_dte >>>'
go

CREATE TABLE dbo.ScheduleCheck
(
    scheduleId       int         NOT NULL,
    dateCreated      datetime    NOT NULL,
    jobId            int         NOT NULL,
    scheduleName     varchar(10) NOT NULL,
    scheduleDesc     varchar(40) NOT NULL,
    expectedDuration int         NOT NULL,
    delayBeforeAlarm int         NOT NULL,
    alertLevel       int         NOT NULL,
    DT1              datetime    NULL,
    DT2              datetime    NULL,
    processInd       bit         NOT NULL
)
LOCK DATAPAGES
go
GRANT SELECT ON dbo.ScheduleCheck TO backmon
go
IF OBJECT_ID('dbo.ScheduleCheck') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.ScheduleCheck >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.ScheduleCheck >>>'
go
CREATE NONCLUSTERED INDEX dte2
    ON dbo.ScheduleCheck(DT2)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.ScheduleCheck') AND name='dte2')
    PRINT '<<< CREATED INDEX dbo.ScheduleCheck.dte2 >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.ScheduleCheck.dte2 >>>'
go
CREATE NONCLUSTERED INDEX SchedCheck_dte
    ON dbo.ScheduleCheck(dateCreated)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.ScheduleCheck') AND name='SchedCheck_dte')
    PRINT '<<< CREATED INDEX dbo.ScheduleCheck.SchedCheck_dte >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.ScheduleCheck.SchedCheck_dte >>>'
go

CREATE TABLE dbo.ScheduleHist
(
    scheduleId       int         NOT NULL,
    dateUpdated      datetime    NOT NULL,
    jobId            int         NOT NULL,
    scheduleName     varchar(10) NOT NULL,
    scheduleDesc     varchar(40) NOT NULL,
    createdBy        int         NOT NULL,
    dateCreated      datetime    NOT NULL,
    modifiedBy       int         NOT NULL,
    dateModified     datetime    NOT NULL,
    cronMin1         int         DEFAULT -1 NOT NULL,
    cronMin2         int         DEFAULT -1 NOT NULL,
    cronMin3         int         DEFAULT -1 NOT NULL,
    cronMin4         int         DEFAULT -1 NOT NULL,
    cronHr1          int         DEFAULT -1 NOT NULL,
    cronHr2          int         DEFAULT -1 NOT NULL,
    cronHr3          int         DEFAULT -1 NOT NULL,
    cronHr4          int         DEFAULT -1 NOT NULL,
    cronSun          bit         DEFAULT 0 NOT NULL,
    cronMon          bit         DEFAULT 0 NOT NULL,
    cronTue          bit         DEFAULT 0 NOT NULL,
    cronWed          bit         DEFAULT 0 NOT NULL,
    cronThu          bit         DEFAULT 0 NOT NULL,
    cronFri          bit         DEFAULT 0 NOT NULL,
    cronSat          bit         DEFAULT 0 NOT NULL,
    cronMonth        int         DEFAULT -1 NOT NULL,
    effectiveFrom    datetime    NOT NULL,
    effectiveTo      datetime    NOT NULL,
    activeStatusInd  char(1)     DEFAULT 'Y' NOT NULL,
    expectedDuration int         NOT NULL,
    delayBeforeAlarm int         NOT NULL,
    scheduleApp      varchar(30) NOT NULL,
    alertLevel       int         NOT NULL,
    CONSTRAINT PK_SCHEDULE
    PRIMARY KEY CLUSTERED (scheduleId,dateUpdated),
    CONSTRAINT ScheduleHi_1029578706
    FOREIGN KEY (scheduleId)
    REFERENCES dbo.Schedule (scheduleId)
)
LOCK ALLPAGES
go
GRANT SELECT ON dbo.ScheduleHist TO backmon
go
IF OBJECT_ID('dbo.ScheduleHist') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.ScheduleHist >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.ScheduleHist >>>'
go

CREATE TABLE dbo.ScheduleId
(
    scheduleId int NOT NULL
)
LOCK ALLPAGES
go
GRANT SELECT ON dbo.ScheduleId TO backmon
go
IF OBJECT_ID('dbo.ScheduleId') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.ScheduleId >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.ScheduleId >>>'
go

CREATE TABLE dbo.SendEmailTmp
(
    jobId               int           NULL,
    jobName             varchar(20)   NULL,
    dateCreated         datetime      NULL,
    condition           varchar(20)   NULL,
    executionId         int           NULL,
    eString             varchar(1000) NULL,
    executionNote       char(255)     NULL,
    executionStatusName char(10)      NULL
)
LOCK ALLPAGES
go
GRANT SELECT ON dbo.SendEmailTmp TO backmon
go
IF OBJECT_ID('dbo.SendEmailTmp') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.SendEmailTmp >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.SendEmailTmp >>>'
go

CREATE TABLE dbo.UserId
(
    userId int NOT NULL
)
LOCK ALLPAGES
go
GRANT SELECT ON dbo.UserId TO backmon
go
IF OBJECT_ID('dbo.UserId') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.UserId >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.UserId >>>'
go

CREATE TABLE dbo.Users
(
    userId          int      NOT NULL,
    suId            smallint NOT NULL,
    uid             smallint NOT NULL,
    dateCreated     datetime NOT NULL,
    createBy        int      NOT NULL,
    activeStatusInd char(1)  NOT NULL,
    dateModified    datetime NOT NULL,
    modifiedBy      int      NOT NULL,
    CONSTRAINT PK_USERID
    PRIMARY KEY CLUSTERED (userId)
)
LOCK ALLPAGES
go
GRANT SELECT ON dbo.Users TO backmon
go
IF OBJECT_ID('dbo.Users') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.Users >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.Users >>>'
go
CREATE UNIQUE NONCLUSTERED INDEX AKusers
    ON dbo.Users(suId,uid)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.Users') AND name='AKusers')
    PRINT '<<< CREATED INDEX dbo.Users.AKusers >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.Users.AKusers >>>'
go

CREATE TABLE dbo.rs_lastcommit
(
    origin           int         NOT NULL,
    origin_qid       binary(36)  NOT NULL,
    secondary_qid    binary(36)  NOT NULL,
    origin_time      datetime    NOT NULL,
    dest_commit_time datetime    NOT NULL,
    pad1             binary(255) NOT NULL,
    pad2             binary(255) NOT NULL,
    pad3             binary(255) NOT NULL,
    pad4             binary(255) NOT NULL,
    pad5             binary(4)   NOT NULL,
    pad6             binary(4)   NOT NULL,
    pad7             binary(4)   NOT NULL,
    pad8             binary(4)   NOT NULL
)
LOCK ALLPAGES
go
IF OBJECT_ID('dbo.rs_lastcommit') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.rs_lastcommit >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.rs_lastcommit >>>'
go
CREATE UNIQUE CLUSTERED INDEX rs_lastcommit_idx
    ON dbo.rs_lastcommit(origin)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.rs_lastcommit') AND name='rs_lastcommit_idx')
    PRINT '<<< CREATED INDEX dbo.rs_lastcommit.rs_lastcommit_idx >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.rs_lastcommit.rs_lastcommit_idx >>>'
go

CREATE TABLE dbo.rs_threads
(
    id   int       NOT NULL,
    seq  int       NOT NULL,
    pad1 char(255) NOT NULL,
    pad2 char(255) NOT NULL,
    pad3 char(255) NOT NULL,
    pad4 char(255) NOT NULL
)
LOCK ALLPAGES
go
GRANT SELECT ON dbo.rs_threads TO public
go
IF OBJECT_ID('dbo.rs_threads') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.rs_threads >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.rs_threads >>>'
go
CREATE UNIQUE CLUSTERED INDEX rs_threads_idx
    ON dbo.rs_threads(id)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.rs_threads') AND name='rs_threads_idx')
    PRINT '<<< CREATED INDEX dbo.rs_threads.rs_threads_idx >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.rs_threads.rs_threads_idx >>>'
go

CREATE TABLE dbo.rs_ticket_history
(
    cnt     numeric(8,0)  IDENTITY,
    h1      varchar(10)   NOT NULL,
    h2      varchar(10)   NOT NULL,
    h3      varchar(10)   NOT NULL,
    h4      varchar(50)   NOT NULL,
    pdb     varchar(30)   NOT NULL,
    prs     varchar(30)   NOT NULL,
    rrs     varchar(30)   NOT NULL,
    rdb     varchar(30)   NOT NULL,
    pdb_t   datetime      NOT NULL,
    exec_t  datetime      NOT NULL,
    dist_t  datetime      NOT NULL,
    rsi_t   datetime      NOT NULL,
    dsi_t   datetime      NOT NULL,
    rdb_t   datetime      DEFAULT getdate() NOT NULL,
    exec_b  int           NOT NULL,
    rsi_b   int           NOT NULL,
    dsi_tnx int           NOT NULL,
    dsi_cmd int           NOT NULL,
    ticket  varchar(1024) NOT NULL
)
LOCK ALLPAGES
go
GRANT UPDATE STATISTICS ON dbo.rs_ticket_history TO public
go
GRANT UPDATE ON dbo.rs_ticket_history TO public
go
GRANT TRUNCATE TABLE ON dbo.rs_ticket_history TO public
go
GRANT SELECT ON dbo.rs_ticket_history TO public
go
GRANT REFERENCES ON dbo.rs_ticket_history TO public
go
GRANT INSERT ON dbo.rs_ticket_history TO public
go
GRANT DELETE ON dbo.rs_ticket_history TO public
go
IF OBJECT_ID('dbo.rs_ticket_history') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.rs_ticket_history >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.rs_ticket_history >>>'
go
CREATE UNIQUE CLUSTERED INDEX rs_ticket_idx
    ON dbo.rs_ticket_history(cnt)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.rs_ticket_history') AND name='rs_ticket_idx')
    PRINT '<<< CREATED INDEX dbo.rs_ticket_history.rs_ticket_idx >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.rs_ticket_history.rs_ticket_idx >>>'
go

CREATE TABLE dbo.Execution
(
    executionId     int          NOT NULL,
    scheduleId      int          NULL,
    createdBy       int          NOT NULL,
    dateCreated     datetime     NOT NULL,
    executionNote   varchar(255) NULL,
    logLocation     varchar(100) NULL,
    executionStatus int          NOT NULL,
    jobSpecificCode int          NULL,
    jobId           int          NOT NULL,
    CONSTRAINT PK_EXECUTION
    PRIMARY KEY CLUSTERED (executionId),
    CONSTRAINT FK_EXECUTIO_REFERENCE_EXECUTIO
    FOREIGN KEY (executionStatus)
    REFERENCES dbo.ExecutionStatus (executionStatus),
    CONSTRAINT FK_EXECUTIO_REFERENCE_JOBSPECI
    FOREIGN KEY (jobSpecificCode)
    REFERENCES dbo.JobSpecificCode (jobSpecificCode),
    CONSTRAINT Execution_1301579675
    FOREIGN KEY (scheduleId)
    REFERENCES dbo.Schedule (scheduleId)
)
LOCK DATAPAGES
go
GRANT SELECT ON dbo.Execution TO backmon
go
IF OBJECT_ID('dbo.Execution') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.Execution >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.Execution >>>'
go
CREATE NONCLUSTERED INDEX Execution_jobId
    ON dbo.Execution(jobId)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.Execution') AND name='Execution_jobId')
    PRINT '<<< CREATED INDEX dbo.Execution.Execution_jobId >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.Execution.Execution_jobId >>>'
go
CREATE NONCLUSTERED INDEX Execution_scedId
    ON dbo.Execution(scheduleId)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.Execution') AND name='Execution_scedId')
    PRINT '<<< CREATED INDEX dbo.Execution.Execution_scedId >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.Execution.Execution_scedId >>>'
go
CREATE NONCLUSTERED INDEX Execution_dte
    ON dbo.Execution(dateCreated)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.Execution') AND name='Execution_dte')
    PRINT '<<< CREATED INDEX dbo.Execution.Execution_dte >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.Execution.Execution_dte >>>'
go

CREATE TABLE dbo.Job
(
    jobId            int         NOT NULL,
    jobTypeId        int         NOT NULL,
    jobName          varchar(20) NOT NULL,
    jobDesc          varchar(40) NOT NULL,
    createdBy        int         NOT NULL,
    dateCreated      datetime    NOT NULL,
    modifiedBy       int         NOT NULL,
    dateModified     datetime    NOT NULL,
    scriptname       varchar(30) NOT NULL,
    activeStatusInd  char(1)     DEFAULT "Y" NOT NULL,
    expectedDuration int         DEFAULT 0 NOT NULL,
    delayBeforeAlarm int         DEFAULT 0 NOT NULL,
    ownerGroup       int         NULL,
    scriptPath       varchar(40) NULL,
    hostId           int         NULL,
    emailId          int         NULL,
    emailCondId      int         NULL,
    nagId            int         NULL,
    CONSTRAINT PK_JOB
    PRIMARY KEY CLUSTERED (jobId),
    CONSTRAINT FK_JOB_REFERENCE_JOBTYPE
    FOREIGN KEY (jobTypeId)
    REFERENCES dbo.JobType (jobTypeId),
    CONSTRAINT Job_1511676433
    FOREIGN KEY (hostId)
    REFERENCES dbo.Host (hostId),
    CONSTRAINT fk_emailId
    FOREIGN KEY (emailId)
    REFERENCES dbo.Email (emailId),
    CONSTRAINT fk_nagiosId
    FOREIGN KEY (nagId)
    REFERENCES dbo.NAGIOSServices (nagId),
    CONSTRAINT fk_emailCondId
    FOREIGN KEY (emailCondId)
    REFERENCES dbo.EmailCondition (emailCondId)
)
LOCK ALLPAGES
go
GRANT SELECT ON dbo.Job TO backmon
go
IF OBJECT_ID('dbo.Job') IS NOT NULL
    PRINT '<<< CREATED TABLE dbo.Job >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE dbo.Job >>>'
go
CREATE NONCLUSTERED INDEX dte
    ON dbo.Job(dateCreated)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.Job') AND name='dte')
    PRINT '<<< CREATED INDEX dbo.Job.dte >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.Job.dte >>>'
go
CREATE NONCLUSTERED INDEX dtem
    ON dbo.Job(dateModified)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.Job') AND name='dtem')
    PRINT '<<< CREATED INDEX dbo.Job.dtem >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.Job.dtem >>>'
go
CREATE NONCLUSTERED INDEX Job_group
    ON dbo.Job(ownerGroup)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.Job') AND name='Job_group')
    PRINT '<<< CREATED INDEX dbo.Job.Job_group >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.Job.Job_group >>>'
go
CREATE NONCLUSTERED INDEX Job_hostId
    ON dbo.Job(hostId)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.Job') AND name='Job_hostId')
    PRINT '<<< CREATED INDEX dbo.Job.Job_hostId >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.Job.Job_hostId >>>'
go

