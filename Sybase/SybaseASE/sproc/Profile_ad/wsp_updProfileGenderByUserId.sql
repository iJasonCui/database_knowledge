IF OBJECT_ID('dbo.wsp_updProfileGenderByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updProfileGenderByUserId
    IF OBJECT_ID('dbo.wsp_updProfileGenderByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updProfileGenderByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updProfileGenderByUserId >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Francisc Schonberger
**   Date:  March 18, 2003
**   Description:  Update gender profile by user id
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_updProfileGenderByUserId
 @productCode   CHAR(1)
,@communityCode CHAR(1)
,@gender        CHAR(1)
,@userId        NUMERIC(12,0)
AS

BEGIN TRAN TRAN_updProfileGenderByUserId

	UPDATE a_profile_dating SET
	gender = @gender
	WHERE user_id = @userId

	IF @@error = 0
    	BEGIN
        	COMMIT TRAN TRAN_updProfileGenderByUserId
        	RETURN 0
    	END
	ELSE
    	BEGIN
        	ROLLBACK TRAN TRAN_updProfileGenderByUserId
        	RETURN 99
    	END
 
go
GRANT EXECUTE ON dbo.wsp_updProfileGenderByUserId TO web
go
IF OBJECT_ID('dbo.wsp_updProfileGenderByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updProfileGenderByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updProfileGenderByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_updProfileGenderByUserId','unchained'
go
