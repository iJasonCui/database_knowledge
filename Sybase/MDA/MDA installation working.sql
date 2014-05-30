sp_configure 'enable cis'

select @@servername

use master
go
sp_addserver loopback, null, @@servername
go

-- Test this configuration: 
set cis_rpc_handling on
-- alternatively, run: sp_configure 'cis rpc handling', 1
go
exec loopback...sp_who  -- note: 3 dots!
go

-- Install the MDA tables. Important: do NOT run this
-- script with 'sqsh' as it'll give errors: 'sqsh' sees 
-- a '$' as the start of a sqsh variable, and this messes
-- up the native RPC names, since these start with a 
-- '$' as well.
-- Solution: either usq 'isql' as below, or run 'sqsh'
-- with the '-Lexpand=0' option to disable sqsh's 
-- variable expansion feature (thanks to Paul Harrington
-- for this tip).
isql -U sa -P yourpassword -S YOURSERVER \
     -i $SYBASE/$SYBASE_ASE/scripts/installmontables

--isql but not sqsh

-- Assign 'mon_role' to logins allowed MDA access 
-- (this also applies to the 'sa' login!)
use master
go
grant role mon_role to sa
go

-- Test basic MDA configuration: 
-- (note: you may need to disconnect/reconnect first
-- to activate 'mon_role' when you just granted this
-- role to the login you're currently using)
select * from master..monState
go


-- Now enable all configuration parameters; 
-- these are all dynamic (except the last one)
-- For all 'pipe' tables, the number of
-- messages is set to 100 here, but you may want 
-- to choose a large size.
--
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
sp_configure "statement pipe max messages", 100
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

-- This is the only static parameter. Set to
-- a higher value (the setting is in bytes
-- per user connection) if you're expecting
-- a lot of (or long) SQL batches
sp_configure "max SQL text monitored", 2048
go

-- The following option must be enabled only when 
-- using DBXRay, so it is not relevant when only 
-- using the MDA tables directly. It is mainly
-- included here for completeness and to pre-empt
-- your questions...
sp_configure "performance monitoring option", 1
go

-- Now you're ready to use the MDA tables. Have fun!
