IF OBJECT_ID('dbo.wsp_GuestEmailSubscribe') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_GuestEmailSubscribe
    IF OBJECT_ID('dbo.wsp_GuestEmailSubscribe') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_GuestEmailSubscribe >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_GuestEmailSubscribe >>>'
END
go
  CREATE PROCEDURE wsp_GuestEmailSubscribe
     @email               char(129)
    ,@gmtTimestamp        int
    ,@signup_adcode       varchar(30) = NULL
    ,@signup_context      char(3) = NULL


AS
IF EXISTS (SELECT * FROM user_info WHERE email = RTRIM(UPPER(@email)))
  BEGIN
    UPDATE user_info
    SET pref_email_news = 'Y'
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
IF NOT EXISTS (SELECT * FROM GuestEmail WHERE email = RTRIM(UPPER(@email)))
  BEGIN
	INSERT GuestEmail
	(
     email
     ,pref_email_news
      ,signup_adcode
       ,signup_context
        ,createdTimestamp
	    ,modifiedTimestamp
	     ,invalidEmail
           ,user_id
            ,registeredTimestamp
    )
    VALUES
	(
     UPPER(@email)
     ,'Y'
      ,@signup_adcode
       ,@signup_context
        ,@gmtTimestamp
	    ,NULL
          ,0
           ,NULL
            ,NULL
    )

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
    SET pref_email_news = 'Y'
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
  END
 
 
go
GRANT EXECUTE ON dbo.wsp_GuestEmailSubscribe TO web
go
IF OBJECT_ID('dbo.wsp_GuestEmailSubscribe') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_GuestEmailSubscribe >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_GuestEmailSubscribe >>>'
go
EXEC sp_procxmode 'dbo.wsp_GuestEmailSubscribe','unchained'
go
