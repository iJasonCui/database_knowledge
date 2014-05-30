use master
go
sp_addserver loopback, null, 'v151db20'
go


USE master
go
EXEC sp_configure 'allow updates to system tables',1
go

select * from sysservers

update sysservers set srvnetname = 'sipdb-19' where srvname = 'loopback'

USE master
go
EXEC sp_configure 'allow updates to system tables',0
go

set cis_rpc_handling on
exec loopback...sp_who 


cd /opt/sybase12_52/ASE-12_5/scripts 

isql -Usa -Ssipdb-17 -i installmontables -o installmontables.log

grant role mon_role to sa


select * from master..monState

sp_configure "enable monitoring", 1
go
sp_configure "sql text pipe active", 1
go
sp_configure "sql text pipe max messages", 100
go
sp_configure "plan text pipe active", 1
go
sp_configure "plan text pipe max messages", 100
go
sp_configure "statement pipe active", 1
go
sp_configure "statement pipe max messages", 100000
go
sp_configure "errorlog pipe active", 1
go
sp_configure "errorlog pipe max messages", 100
go
sp_configure "deadlock pipe active", 1
go
sp_configure "deadlock pipe max messages", 100
go
sp_configure "wait event timing", 1
go
sp_configure "process wait events", 1
go
sp_configure "object lockwait timing", 1
go
sp_configure "SQL batch capture", 1
go
sp_configure "statement statistics active", 1
go
sp_configure "per object statistics active", 1
go

-- 
-- As of ASE 15.0.2, also run the following one:
--
sp_configure "enable stmt cache monitoring", 1
go


-- This is the only static parameter. Set to
-- a higher value (the setting is in bytes
-- per user connection) if you're expecting
-- a lot of (or long) SQL batches
sp_configure "max SQL text monitored", 2048
go


USE master
go
CREATE DATABASE mda_db
    ON invDB_data=200
    LOG ON invDB_log=100
go
USE master
go
EXEC sp_dboption 'mda_db','select into/bulkcopy/pllsort',true
go
EXEC sp_dboption 'mda_db','trunc log on chkpt',true
go
USE mda_db
go
CHECKPOINT
go
USE mda_db
go
EXEC sp_changedbowner 'sa'
go
IF DB_ID('mda_db') IS NOT NULL
    PRINT '<<< CREATED DATABASE mda_db >>>'
ELSE
    PRINT '<<< FAILED CREATING DATABASE mda_db >>>'
go



