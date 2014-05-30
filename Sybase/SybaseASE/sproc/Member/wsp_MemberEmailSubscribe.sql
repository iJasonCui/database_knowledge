IF OBJECT_ID('dbo.wsp_MemberEmailSubscribe') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_MemberEmailSubscribe
    IF OBJECT_ID('dbo.wsp_MemberEmailSubscribe') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_MemberEmailSubscribe >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_MemberEmailSubscribe >>>'
END
go
  CREATE PROCEDURE wsp_MemberEmailSubscribe
     @user_id               numeric(12,0)
    ,@pref_email_news       char(1)
AS

  BEGIN
    UPDATE user_info
    SET pref_email_news = @pref_email_news
    WHERE user_id = @user_id
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
GRANT EXECUTE ON dbo.wsp_MemberEmailSubscribe TO web
go
IF OBJECT_ID('dbo.wsp_MemberEmailSubscribe') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_MemberEmailSubscribe >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_MemberEmailSubscribe >>>'
go
EXEC sp_procxmode 'dbo.wsp_MemberEmailSubscribe','unchained'
go
