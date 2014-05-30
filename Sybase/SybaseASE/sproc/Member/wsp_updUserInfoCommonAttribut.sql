IF OBJECT_ID('dbo.wsp_updUserInfoCommonAttribut') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updUserInfoCommonAttribut
    IF OBJECT_ID('dbo.wsp_updUserInfoCommonAttribut') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updUserInfoCommonAttribut >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updUserInfoCommonAttribut >>>'
END
go
 /***********************************************************************
**
** CREATION:
**   Author:  Jeff Yang 
**   Date:  Oct. 20 2002
**   Description:  Updates common row on profile(after creating a new profile)
**
**   Author: Mike Stairs
**   Date: Oct 2005
**   Description: eliminated references to removed columns from user_info
**
*************************************************************************/

CREATE PROCEDURE  wsp_updUserInfoCommonAttribut
 @userId NUMERIC(12,0)
,@body_type char(1)
,@ethnic char(1)
,@religion char(1)
,@smoke char(1)
,@height_cm tinyint

AS

DECLARE @dateNow DATETIME
DECLARE @return INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
	
IF @return != 0
BEGIN
    RETURN @return
END

BEGIN TRAN TRAN_updUserInfoCommonAttribut
     UPDATE user_info SET
		      body_type=@body_type,
		      ethnic=@ethnic,
		      religion=@religion,
		      smoke=@smoke,
		      height_cm=@height_cm,
                      dateModified=@dateNow

     WHERE user_id=@userId

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_updUserInfoCommonAttribut
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_updUserInfoCommonAttribut
            RETURN 99
        END
 
go
GRANT EXECUTE ON dbo.wsp_updUserInfoCommonAttribut TO web
go
IF OBJECT_ID('dbo.wsp_updUserInfoCommonAttribut') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updUserInfoCommonAttribut >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updUserInfoCommonAttribut >>>'
go
EXEC sp_procxmode 'dbo.wsp_updUserInfoCommonAttribut','unchained'
go
