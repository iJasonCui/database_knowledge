IF OBJECT_ID('dbo.sp__dbo_only') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.sp__dbo_only
    IF OBJECT_ID('dbo.sp__dbo_only') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.sp__dbo_only >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.sp__dbo_only >>>'
END
go

create proc sp__dbo_only @dbname varchar(31)
as

select case when status & (2048)= 2048 then 'Y' else 'N' end as DboStatus
from master..sysdatabases
where name = @dbname

return

go
EXEC sp_procxmode 'dbo.sp__dbo_only','unchained'
go
IF OBJECT_ID('dbo.sp__dbo_only') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.sp__dbo_only >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.sp__dbo_only >>>'
go
GRANT EXECUTE ON dbo.sp__dbo_only TO public
go

