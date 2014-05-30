USE Member
go
IF OBJECT_ID('dbo.wsp_getMailboxFlag') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMailboxFlag
    IF OBJECT_ID('dbo.wsp_getMailboxFlag') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMailboxFlag >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMailboxFlag >>>'
END
go

CREATE PROCEDURE  wsp_getMailboxFlag
@userId  NUMERIC(12,0)
AS

BEGIN
    SELECT mailboxFlag
      FROM MailboxPref
     WHERE userId = @userId

    RETURN @@error
END
go
EXEC sp_procxmode 'dbo.wsp_getMailboxFlag', 'unchained'
go
IF OBJECT_ID('dbo.wsp_getMailboxFlag') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getMailboxFlag >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMailboxFlag >>>'
go
GRANT EXECUTE ON dbo.wsp_getMailboxFlag TO web
go

