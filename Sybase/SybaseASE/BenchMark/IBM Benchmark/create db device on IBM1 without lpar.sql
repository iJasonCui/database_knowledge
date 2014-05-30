--sybase 15 IBM1 without LPAR internal disk

select convert(varchar(40), getdate(), 109)

USE master
go
DISK INIT
    NAME='Internal_data1',
    PHYSNAME='/sybase/sybase15/data/Internal_data1.dev',
    VDEVNO=4,
    SIZE=4194304,
    VSTART=0,
    CNTRLTYPE=0, 
    DSYNC=true
go
EXEC sp_diskdefault 'Internal_data1',defaultoff
go

select convert(varchar(40), getdate(), 109)


--81secs

Feb  8 2008  1:06:09:076PM
Feb  8 2008  1:07:30:170PM



--sybase 12_5 IBM1 without LPAR internal disk

select convert(varchar(40), getdate(), 109)

USE master
go
DISK INIT
    NAME='Internal_data1',
    PHYSNAME='/sybase/sybase12_5/data/Internal_data1.dev',
    VDEVNO=4,
    SIZE=4194304,
    VSTART=0,
    CNTRLTYPE=0, 
    DSYNC=true
go
EXEC sp_diskdefault 'Internal_data1',defaultoff
go

select convert(varchar(40), getdate(), 109)

--82secs

--Feb  8 2008  7:26:46:863PM
--Feb  8 2008  7:28:08:733PM

USE master
go
DISK INIT
    NAME='Netapp_data1',
    PHYSNAME='/netapp/db/sybase15/Netapp_data1.dev',
    VDEVNO=6,
    SIZE=4194304,
    VSTART=0,
    CNTRLTYPE=0, 
    DSYNC=true
go
EXEC sp_diskdefault 'Netapp_data1',defaultoff
go

select convert(varchar(40), getdate(), 109)

--Feb  8 2008  7:41:43:960PM
--Feb  8 2008  7:44:12:626PM

--150secs

--#-------------------------------#
--AIX 6.1 netapp
--May  9 2008  3:45:56:680PM
--May  9 2008  3:48:28:380PM
--150secons
--#-------------------------------#


--#-------------------------------#
--AIX 6.1 internal disk

select convert(varchar(40), getdate(), 109)

USE master
go
DISK INIT
    NAME='Internal_data1',
    PHYSNAME='/sybase_15/data/Internal_data1.dev',
    VDEVNO=4,
    SIZE=4194304,
    VSTART=0,
    CNTRLTYPE=0, 
    DSYNC=true
go
EXEC sp_diskdefault 'Internal_data1',defaultoff
go

select convert(varchar(40), getdate(), 109)

--May  9 2008  3:53:14:033PM
--May  9 2008  3:54:50:006PM
--96 seconds


