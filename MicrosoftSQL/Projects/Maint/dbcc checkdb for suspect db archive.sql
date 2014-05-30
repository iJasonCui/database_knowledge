--dbcc checkdb('archive')

--DBCC CHECKDB ('archive') WITH NO_INFOMSGS, ALL_ERRORMSGS

EXEC sp_resetstatus 'archive'

ALTER DATABASE archive SET EMERGENCY 

DBCC checkdb('archive')

ALTER DATABASE archive SET SINGLE_USER WITH ROLLBACK IMMEDIATE

DBCC CheckDB ('archive', REPAIR_ALLOW_DATA_LOSS)

DBCC Checktable('archive.web.admin_notes', REPAIR_ALLOW_DATA_LOSS)

DBCC Checktable('archive.web.admin_notes',REPAIR_REBUILD)

DBCC Checktable('archive.web.admin_notes')

DBCC Checktable('archive.ivr.CallLog', REPAIR_ALLOW_DATA_LOSS)

DBCC Checktable('archive.ivr.CallLog')

DBCC Checktable('archive.ivr.Mailbox', REPAIR_ALLOW_DATA_LOSS)

DBCC Checktable('archive.ivr.Mailbox')

DBCC Checktable('archive.ivr.Message', REPAIR_ALLOW_DATA_LOSS)

DBCC Checktable('archive.ivr.Message')


ALTER DATABASE archive SET MULTI_USER

--ALTER DATABASE archive SET online

select count(*) from archive.web.admin_notes

--select * into athenaeum.web.admin_notes from archive.web.admin_notes

--drop table archive.web.admin_notes