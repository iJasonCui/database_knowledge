IF OBJECT_ID('dbo.wsp_getUserInfoFirstPictTime') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserInfoFirstPictTime
    IF OBJECT_ID('dbo.wsp_getUserInfoFirstPictTime') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserInfoFirstPictTime >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserInfoFirstPictTime >>>'
END
go
  /***********************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  June 6, 2002
**   Description:  Retrieves firstpicturetime, etc for a given user id
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: June 23, 2004
**   Description: return localePref too
**
*************************************************************************/

CREATE PROCEDURE  wsp_getUserInfoFirstPictTime
@userId        NUMERIC(12,0)
AS

BEGIN
	SELECT username,gender,birthdate,email,firstpicturetime as timestamp, localePref
	FROM user_info
	WHERE user_id = @userId

	RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_getUserInfoFirstPictTime TO web
go
IF OBJECT_ID('dbo.wsp_getUserInfoFirstPictTime') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserInfoFirstPictTime >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserInfoFirstPictTime >>>'
go
EXEC sp_procxmode 'dbo.wsp_getUserInfoFirstPictTime','unchained'
go
