IF OBJECT_ID('dbo.wsp_updUserInfoHeightByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updUserInfoHeightByUserId
    IF OBJECT_ID('dbo.wsp_updUserInfoHeightByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updUserInfoHeightByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updUserInfoHeightByUserId >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Yan L
**   Date:  Feb 20 2004
**   Description:  Update user info height and preference by user id
**
**   Author: Mike Stairs
**   Date: Oct 2005
**   Description: added dateModified to user_info
**
******************************************************************************/

CREATE PROCEDURE wsp_updUserInfoHeightByUserId
    @userId           NUMERIC(12,0),
    @preferredUnits   CHAR(1),
    @heightCm         tinyint
AS

DECLARE @dateNow DATETIME
DECLARE @return INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
	
IF @return != 0
BEGIN
  RETURN @return
END

BEGIN TRAN TRAN_updUserInfoHeightByUserId 
    UPDATE user_info
       SET preferred_units = @preferredUnits, 
           height_cm       = @heightCm,
           dateModified    = @dateNow

     WHERE user_id = @userId

    IF @@error = 0
        BEGIN
                COMMIT TRAN TRAN_updUserInfoHeightByUserId
                RETURN 0
    	END
    ELSE
    	BEGIN
                ROLLBACK TRAN TRAN_updUserInfoHeightByUserId
                RETURN 99
        END 
go

GRANT EXECUTE ON dbo.wsp_updUserInfoHeightByUserId TO web
go
IF OBJECT_ID('dbo.wsp_updUserInfoHeightByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updUserInfoHeightByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updUserInfoHeightByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_updUserInfoHeightByUserId','unchained'
go
