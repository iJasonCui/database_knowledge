IF OBJECT_ID('dbo.wsp_updFirstPictureTime') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updFirstPictureTime
    IF OBJECT_ID('dbo.wsp_updFirstPictureTime') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updFirstPictureTime >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updFirstPictureTime >>>'
END
go
  CREATE PROCEDURE wsp_updFirstPictureTime
 @userId NUMERIC(12,0)
,@firstpicturetime INT
AS
/******************************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  Apr 26 2002
**   Description:  Update firstpicturetime column of user_info by user_id if
**                 set to NULL
**
**   Author: Mike Stairs
**   Date: Oct 2005
**   Description: added dateModified to user_info
**
******************************************************************************/

DECLARE @dateNow DATETIME
DECLARE @return INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
	
IF @return != 0
BEGIN
  RETURN @return
END

BEGIN TRAN TRAN_updFirstPictureTime

    UPDATE user_info SET
    firstpicturetime = @firstpicturetime
   ,dateModified = @dateNow
    WHERE user_id = @userId
    AND firstpicturetime = NULL

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_updFirstPictureTime
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_updFirstPictureTime
            RETURN 99
        END 
 
go
GRANT EXECUTE ON dbo.wsp_updFirstPictureTime TO web
go
IF OBJECT_ID('dbo.wsp_updFirstPictureTime') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updFirstPictureTime >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updFirstPictureTime >>>'
go
EXEC sp_procxmode 'dbo.wsp_updFirstPictureTime','unchained'
go
