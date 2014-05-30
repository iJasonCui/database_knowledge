IF OBJECT_ID('dbo.wsp_GuestEmailInvalid') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_GuestEmailInvalid
    IF OBJECT_ID('dbo.wsp_GuestEmailInvalid') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_GuestEmailInvalid >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_GuestEmailInvalid >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Yan Liu/Jack Veiga
**   Date:  May 2003
**   Description:  
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE wsp_GuestEmailInvalid
 @email        VARCHAR(129)
,@gmtTimestamp INT
AS
DECLARE @userId NUMERIC(12,0)
,@return        INT

SELECT @email = RTRIM(UPPER(@email))

SELECT @userId = user_id
FROM user_info
WHERE email = @email

IF @@rowcount = 1

  BEGIN

	BEGIN TRAN TRAN_GuestEmailInvalid

	EXEC @return = wsp_saveEmailHistory @userId, @email, 'U', 0, 'U'

    IF @return = 0
		BEGIN
    		UPDATE user_info
    		SET emailStatus = 'U'
    		WHERE email = @email

			IF @@error = 0
				BEGIN
					COMMIT TRAN TRAN_GuestEmailInvalid
					RETURN 0
				END
			ELSE
				BEGIN
					ROLLBACK TRAN TRAN_GuestEmailInvalid
					RETURN 99
				END
		END
	ELSE
		BEGIN
			ROLLBACK TRAN TRAN_GuestEmailInvalid
			RETURN 99
		END

  END

ELSE

  BEGIN

	BEGIN TRAN TRAN_GuestEmailInvalid

    UPDATE GuestEmail
    SET pref_email_news = 'N'
       ,modifiedTimestamp = @gmtTimestamp
       ,invalidEmail = 1
    WHERE email = @email
    AND registeredTimestamp = NULL

	IF @@error = 0
		BEGIN
			COMMIT TRAN TRAN_GuestEmailInvalid
			RETURN 0
		END
	ELSE
		BEGIN
			ROLLBACK TRAN TRAN_GuestEmailInvalid
			RETURN 99
		END

  END
 
go
GRANT EXECUTE ON dbo.wsp_GuestEmailInvalid TO web
go
IF OBJECT_ID('dbo.wsp_GuestEmailInvalid') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_GuestEmailInvalid >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_GuestEmailInvalid >>>'
go
EXEC sp_procxmode 'dbo.wsp_GuestEmailInvalid','unchained'
go
