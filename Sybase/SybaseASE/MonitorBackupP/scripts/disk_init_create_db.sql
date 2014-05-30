USE master
go
DISK INIT
    NAME='BackupDev1',
    PHYSNAME='/data/db/Backup1.Dev',
    VDEVNO=4,
    SIZE=1310720,
    VSTART=0,
    CNTRLTYPE=0, 
    DSYNC=true
go
EXEC sp_diskdefault 'BackupDev1',defaultoff
go
IF EXISTS (SELECT * FROM master.dbo.sysdevices WHERE name='BackupDev1')
    PRINT '<<< CREATED DATABASE DEVICE BackupDev1 >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE DEVICE BackupDev1 >>>'
go

USE master
go
DISK INIT
    NAME='BackupDev2',
    PHYSNAME='/data/db/Backup2.Dev',
    VDEVNO=5,
    SIZE=1048576,
    VSTART=0,
    CNTRLTYPE=0, 
    DSYNC=true
go
EXEC sp_diskdefault 'BackupDev2',defaultoff
go
IF EXISTS (SELECT * FROM master.dbo.sysdevices WHERE name='BackupDev2')
    PRINT '<<< CREATED DATABASE DEVICE BackupDev2 >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE DEVICE BackupDev2 >>>'
go


USE master
go
CREATE DATABASE MonitorBackupP
    ON BackupDev1=512
    LOG ON BackupDev2=256
go
ALTER DATABASE MonitorBackupP 
    ON BackupDev1=256
go
ALTER DATABASE MonitorBackupP 
    ON BackupDev1=768
go
ALTER DATABASE MonitorBackupP 
    ON BackupDev1=100
go
ALTER DATABASE MonitorBackupP 
    ON BackupDev1=412
go
USE master
go
EXEC sp_dboption 'MonitorBackupP','trunc log on chkpt',true
go
USE MonitorBackupP
go
CHECKPOINT
go
USE MonitorBackupP
go
EXEC sp_changedbowner 'sa'
go
IF DB_ID('MonitorBackupP') IS NOT NULL
    PRINT '<<< CREATED DATABASE MonitorBackupP >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE MonitorBackupP >>>'
go


