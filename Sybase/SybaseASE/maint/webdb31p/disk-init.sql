USE master
go
DISK INIT
    NAME='wdata1',
    PHYSNAME='/data/db/wdata1.dev',
    VDEVNO=4,
    SIZE=2097152,
    VSTART=0,
    CNTRLTYPE=0, 
    DSYNC=false
go
EXEC sp_diskdefault 'wdata1',defaultoff
go
IF EXISTS (SELECT * FROM master.dbo.sysdevices WHERE name='wdata1')
    PRINT '<<< CREATED DATABASE DEVICE wdata1 >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE DEVICE wdata1 >>>'
go

USE master
go
DISK INIT
    NAME='wdata10',
    PHYSNAME='/ccs/db/wdata10.dev',
    VDEVNO=6,
    SIZE=2097152,
    VSTART=0,
    CNTRLTYPE=0, 
    DSYNC=false
go
EXEC sp_diskdefault 'wdata10',defaultoff
go
IF EXISTS (SELECT * FROM master.dbo.sysdevices WHERE name='wdata10')
    PRINT '<<< CREATED DATABASE DEVICE wdata10 >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE DEVICE wdata10 >>>'
go

USE master
go
DISK INIT
    NAME='wdata11',
    PHYSNAME='/ccs/db/wdata11.dev',
    VDEVNO=7,
    SIZE=1114112,
    VSTART=0,
    CNTRLTYPE=0, 
    DSYNC=false
go
EXEC sp_diskdefault 'wdata11',defaultoff
go
IF EXISTS (SELECT * FROM master.dbo.sysdevices WHERE name='wdata11')
    PRINT '<<< CREATED DATABASE DEVICE wdata11 >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE DEVICE wdata11 >>>'
go

USE master
go
DISK INIT
    NAME='wdata12',
    PHYSNAME='/ccs/db/wdata12.dev',
    VDEVNO=15,
    SIZE=1048576,
    VSTART=0,
    CNTRLTYPE=0, 
    DSYNC=false
go
EXEC sp_diskdefault 'wdata12',defaultoff
go
IF EXISTS (SELECT * FROM master.dbo.sysdevices WHERE name='wdata12')
    PRINT '<<< CREATED DATABASE DEVICE wdata12 >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE DEVICE wdata12 >>>'
go

USE master
go
DISK INIT
    NAME='wdata13',
    PHYSNAME='/ccs/db/wdata13.dev',
    VDEVNO=16,
    SIZE=1048576,
    VSTART=0,
    CNTRLTYPE=0, 
    DSYNC=false
go
EXEC sp_diskdefault 'wdata13',defaultoff
go
IF EXISTS (SELECT * FROM master.dbo.sysdevices WHERE name='wdata13')
    PRINT '<<< CREATED DATABASE DEVICE wdata13 >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE DEVICE wdata13 >>>'
go

USE master
go
DISK INIT
    NAME='wdata2',
    PHYSNAME='/data/db/wdata2.dev',
    VDEVNO=5,
    SIZE=2097152,
    VSTART=0,
    CNTRLTYPE=0, 
    DSYNC=false
go
EXEC sp_diskdefault 'wdata2',defaultoff
go
IF EXISTS (SELECT * FROM master.dbo.sysdevices WHERE name='wdata2')
    PRINT '<<< CREATED DATABASE DEVICE wdata2 >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE DEVICE wdata2 >>>'
go

USE master
go
DISK INIT
    NAME='wdata3',
    PHYSNAME='/data/db/wdata3.dev',
    VDEVNO=11,
    SIZE=1048576,
    VSTART=0,
    CNTRLTYPE=0, 
    DSYNC=false
go
EXEC sp_diskdefault 'wdata3',defaultoff
go
IF EXISTS (SELECT * FROM master.dbo.sysdevices WHERE name='wdata3')
    PRINT '<<< CREATED DATABASE DEVICE wdata3 >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE DEVICE wdata3 >>>'
go

USE master
go
DISK INIT
    NAME='wdata4',
    PHYSNAME='/data/db/wdata4.dev',
    VDEVNO=12,
    SIZE=1048576,
    VSTART=0,
    CNTRLTYPE=0, 
    DSYNC=false
go
EXEC sp_diskdefault 'wdata4',defaultoff
go
IF EXISTS (SELECT * FROM master.dbo.sysdevices WHERE name='wdata4')
    PRINT '<<< CREATED DATABASE DEVICE wdata4 >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE DEVICE wdata4 >>>'
go

USE master
go
DISK INIT
    NAME='wdata5',
    PHYSNAME='/data/db/wdata5.dev',
    VDEVNO=13,
    SIZE=1048576,
    VSTART=0,
    CNTRLTYPE=0, 
    DSYNC=false
go
EXEC sp_diskdefault 'wdata5',defaultoff
go
IF EXISTS (SELECT * FROM master.dbo.sysdevices WHERE name='wdata5')
    PRINT '<<< CREATED DATABASE DEVICE wdata5 >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE DEVICE wdata5 >>>'
go

USE master
go
DISK INIT
    NAME='wdata6',
    PHYSNAME='/data/db/wdata6.dev',
    VDEVNO=14,
    SIZE=1048576,
    VSTART=0,
    CNTRLTYPE=0, 
    DSYNC=false
go
EXEC sp_diskdefault 'wdata6',defaultoff
go
IF EXISTS (SELECT * FROM master.dbo.sysdevices WHERE name='wdata6')
    PRINT '<<< CREATED DATABASE DEVICE wdata6 >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE DEVICE wdata6 >>>'
go

USE master
go
DISK INIT
    NAME='wlog1',
    PHYSNAME='/data/db/wlog1.dev',
    VDEVNO=8,
    SIZE=655360,
    VSTART=0,
    CNTRLTYPE=0, 
    DSYNC=false
go
EXEC sp_diskdefault 'wlog1',defaultoff
go
IF EXISTS (SELECT * FROM master.dbo.sysdevices WHERE name='wlog1')
    PRINT '<<< CREATED DATABASE DEVICE wlog1 >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE DEVICE wlog1 >>>'
go

USE master
go
DISK INIT
    NAME='wlog2',
    PHYSNAME='/ccs/db/wlog2.dev',
    VDEVNO=9,
    SIZE=524288,
    VSTART=0,
    CNTRLTYPE=0, 
    DSYNC=false
go
EXEC sp_diskdefault 'wlog2',defaultoff
go
IF EXISTS (SELECT * FROM master.dbo.sysdevices WHERE name='wlog2')
    PRINT '<<< CREATED DATABASE DEVICE wlog2 >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE DEVICE wlog2 >>>'
go

USE master
go
DISK INIT
    NAME='wlog3',
    PHYSNAME='/ccs/db/wlog3.dev',
    VDEVNO=10,
    SIZE=524288,
    VSTART=0,
    CNTRLTYPE=0, 
    DSYNC=false
go
EXEC sp_diskdefault 'wlog3',defaultoff
go
IF EXISTS (SELECT * FROM master.dbo.sysdevices WHERE name='wlog3')
    PRINT '<<< CREATED DATABASE DEVICE wlog3 >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE DEVICE wlog3 >>>'
go

USE master
go
DISK INIT
    NAME='wlog4',
    PHYSNAME='/data/db/wlog4.dev',
    VDEVNO=17,
    SIZE=524288,
    VSTART=0,
    CNTRLTYPE=0, 
    DSYNC=false
go
EXEC sp_diskdefault 'wlog4',defaultoff
go
IF EXISTS (SELECT * FROM master.dbo.sysdevices WHERE name='wlog4')
    PRINT '<<< CREATED DATABASE DEVICE wlog4 >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE DEVICE wlog4 >>>'
go

USE master
go
DISK INIT
    NAME='wlog5',
    PHYSNAME='/data/db/wlog5.dev',
    VDEVNO=18,
    SIZE=524288,
    VSTART=0,
    CNTRLTYPE=0, 
    DSYNC=false
go
EXEC sp_diskdefault 'wlog5',defaultoff
go
IF EXISTS (SELECT * FROM master.dbo.sysdevices WHERE name='wlog5')
    PRINT '<<< CREATED DATABASE DEVICE wlog5 >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE DEVICE wlog5 >>>'
go

USE master
go
DISK INIT
    NAME='wlog6',
    PHYSNAME='/ccs/db/wlog6.dev',
    VDEVNO=19,
    SIZE=524288,
    VSTART=0,
    CNTRLTYPE=0, 
    DSYNC=false
go
EXEC sp_diskdefault 'wlog6',defaultoff
go
IF EXISTS (SELECT * FROM master.dbo.sysdevices WHERE name='wlog6')
    PRINT '<<< CREATED DATABASE DEVICE wlog6 >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE DEVICE wlog6 >>>'
go

USE master
go
DISK INIT
    NAME='wlog7',
    PHYSNAME='/ccs/db/wlog7.dev',
    VDEVNO=20,
    SIZE=524288,
    VSTART=0,
    CNTRLTYPE=0, 
    DSYNC=false
go
EXEC sp_diskdefault 'wlog7',defaultoff
go
IF EXISTS (SELECT * FROM master.dbo.sysdevices WHERE name='wlog7')
    PRINT '<<< CREATED DATABASE DEVICE wlog7 >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE DEVICE wlog7 >>>'
go

