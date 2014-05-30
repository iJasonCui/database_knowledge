IF OBJECT_ID('dbo.wsp_GuestEmailMemberSignUp') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_GuestEmailMemberSignUp
    IF OBJECT_ID('dbo.wsp_GuestEmailMemberSignUp') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_GuestEmailMemberSignUp >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_GuestEmailMemberSignUp >>>'
END
go
  CREATE PROCEDURE wsp_GuestEmailMemberSignUp
     @email               char(129)
    ,@gmtTimestamp        int
    ,@user_id             numeric(12,0)

AS
IF EXISTS (SELECT * FROM GuestEmail WHERE email = RTRIM(UPPER(@email)))
  BEGIN
    UPDATE GuestEmail
    SET user_id = @user_id, registeredTimestamp = @gmtTimestamp, modifiedTimestamp = @gmtTimestamp
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
GRANT EXECUTE ON dbo.wsp_GuestEmailMemberSignUp TO web
go
IF OBJECT_ID('dbo.wsp_GuestEmailMemberSignUp') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_GuestEmailMemberSignUp >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_GuestEmailMemberSignUp >>>'
go
EXEC sp_procxmode 'dbo.wsp_GuestEmailMemberSignUp','unchained'
go
