IF OBJECT_ID('dbo.wsp_GuestEmailUnsubscribe') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_GuestEmailUnsubscribe
    IF OBJECT_ID('dbo.wsp_GuestEmailUnsubscribe') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_GuestEmailUnsubscribe >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_GuestEmailUnsubscribe >>>'
END
go
  CREATE PROCEDURE wsp_GuestEmailUnsubscribe
     @email               char(129)
    ,@gmtTimestamp        int

AS
IF EXISTS (SELECT * FROM user_info WHERE email = RTRIM(UPPER(@email)))
  BEGIN
    UPDATE user_info
    SET pref_email_news = 'N'
    WHERE email = RTRIM(UPPER(@email))
    IF @@error != 0
	BEGIN
		RETURN 99
	END
    ELSE
    BEGIN
       RETURN 0
    END
  END
ELSE
  BEGIN
    UPDATE GuestEmail
    SET pref_email_news = 'N'
       ,modifiedTimestamp = @gmtTimestamp
    WHERE email = RTRIM(UPPER(@email))
    AND registeredTimestamp = NULL
     IF @@error != 0
	BEGIN
		RETURN 99
	END
    ELSE
    BEGIN
       RETURN 0
    END
  END
 
 
go
GRANT EXECUTE ON dbo.wsp_GuestEmailUnsubscribe TO web
go
IF OBJECT_ID('dbo.wsp_GuestEmailUnsubscribe') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_GuestEmailUnsubscribe >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_GuestEmailUnsubscribe >>>'
go
EXEC sp_procxmode 'dbo.wsp_GuestEmailUnsubscribe','unchained'
go
