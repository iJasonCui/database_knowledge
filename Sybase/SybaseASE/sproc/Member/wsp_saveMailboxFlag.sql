USE Member
go
IF OBJECT_ID('dbo.wsp_saveMailboxFlag') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveMailboxFlag
    IF OBJECT_ID('dbo.wsp_saveMailboxFlag') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveMailboxFlag >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveMailboxFlag >>>'
END
go

CREATE PROCEDURE  wsp_saveMailboxFlag
@userId  NUMERIC(12,0),
@mailboxFlag CHAR(1)
AS

BEGIN

DECLARE @now DATETIME

SELECT @now = getdate()

IF EXISTS (SELECT 1 FROM MailboxPref WHERE userId = @userId)
BEGIN
    UPDATE MailboxPref SET mailboxFlag = @mailboxFlag, dateModified = @now WHERE userId = @userId
    RETURN
END

INSERT into MailboxPref(userId, mailboxFlag, dateCreated, dateModified) values(@userId, @mailboxFlag, @now, @now)

END
go
EXEC sp_procxmode 'dbo.wsp_saveMailboxFlag', 'unchained'
go
IF OBJECT_ID('dbo.wsp_saveMailboxFlag') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_saveMailboxFlag >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveMailboxFlag >>>'
go
GRANT EXECUTE ON dbo.wsp_saveMailboxFlag TO web
go

