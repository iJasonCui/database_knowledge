IF OBJECT_ID('dbo.wsp_updUserInfoTypeByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updUserInfoTypeByUserId
    IF OBJECT_ID('dbo.wsp_updUserInfoTypeByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updUserInfoTypeByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updUserInfoTypeByUserId >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  June 6 2002
**   Description:  Update user type by user id
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_updUserInfoTypeByUserId
 @userType CHAR(1)
,@userId   NUMERIC(12,0)
,@xactionId int 
AS
DECLARE @firstPayTime INT
DECLARE @dateNow DATETIME
DECLARE @return INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
	
IF @return != 0
BEGIN
  RETURN @return
END

SELECT @firstPayTime = firstpaytime
FROM user_info
WHERE user_id = @userId

IF @@error != 0
	BEGIN
		RETURN 99
	END

IF @userType = 'P' AND @firstPayTime = NULL
	BEGIN
		DECLARE @getdate DATETIME

		SELECT @getdate = GETDATE()
		EXEC @return = wsp_convertTimestamp @getdate, @firstPayTime OUTPUT, NULL
		IF @return !=0
			BEGIN
				RETURN 99
			END

		BEGIN TRAN TRAN_updUserInfoTypeByUserId

		UPDATE user_info SET
		 user_type = @userType
		,firstpaytime = @firstPayTime
		,first_xactionId = @xactionId
                ,dateModified    = @dateNow
		WHERE user_id = @userId

		IF @@error = 0
    		BEGIN
        		COMMIT TRAN TRAN_updUserInfoTypeByUserId
        		RETURN 0
    		END
		ELSE
    		BEGIN
        		ROLLBACK TRAN TRAN_updUserInfoTypeByUserId
        		RETURN 99
    		END 
	END

ELSE

	BEGIN
		BEGIN TRAN TRAN_updUserInfoTypeByUserId

		UPDATE user_info SET
		user_type = @userType,
                dateModified    = @dateNow
		WHERE user_id = @userId

		IF @@error = 0
    		BEGIN
        		COMMIT TRAN TRAN_updUserInfoTypeByUserId
        		RETURN 0
    		END
		ELSE
    		BEGIN
        		ROLLBACK TRAN TRAN_updUserInfoTypeByUserId
        		RETURN 99
    		END 
	END
 
go
GRANT EXECUTE ON dbo.wsp_updUserInfoTypeByUserId TO web
go
IF OBJECT_ID('dbo.wsp_updUserInfoTypeByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updUserInfoTypeByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updUserInfoTypeByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_updUserInfoTypeByUserId','unchained'
go
