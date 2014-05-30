--dbcc checkdb('athenaeum')

--DBCC CHECKDB ('athenaeum') WITH NO_INFOMSGS, ALL_ERRORMSGS

EXEC sp_resetstatus 'athenaeum'

ALTER DATABASE athenaeum SET EMERGENCY 

DBCC checkdb('athenaeum')

ALTER DATABASE athenaeum SET SINGLE_USER WITH ROLLBACK IMMEDIATE

DBCC CheckDB ('athenaeum', REPAIR_ALLOW_DATA_LOSS)

DBCC Checktable('archive.web.admin_notes', REPAIR_ALLOW_DATA_LOSS)

DBCC Checktable('archive.web.admin_notes',REPAIR_REBUILD)

DBCC Checktable('archive.web.admin_notes')

DBCC Checktable('archive.ivr.CallLog', REPAIR_ALLOW_DATA_LOSS)

DBCC Checktable('archive.ivr.CallLog')

DBCC Checktable('archive.ivr.Mailbox', REPAIR_ALLOW_DATA_LOSS)

DBCC Checktable('archive.ivr.Mailbox')

DBCC Checktable('archive.ivr.Message', REPAIR_ALLOW_DATA_LOSS)

DBCC Checktable('archive.ivr.Message')


ALTER DATABASE athenaeum SET MULTI_USER

--ALTER DATABASE archive SET online

select count(*) from archive.web.admin_notes

--select * into athenaeum.web.admin_notes from archive.web.admin_notes

--drop table archive.web.admin_notes