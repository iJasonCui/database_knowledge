IF OBJECT_ID('dbo.wsp_getUserInfoFirstIdentTime') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserInfoFirstIdentTime
    IF OBJECT_ID('dbo.wsp_getUserInfoFirstIdentTime') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserInfoFirstIdentTime >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserInfoFirstIdentTime >>>'
END
go
  /***********************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  June 6, 2002
**   Description:  Retrieves firstidentitytime, etc for a given user id
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: June 23, 2004
**   Description: return localePref too
**
*************************************************************************/

CREATE PROCEDURE dbo.wsp_getUserInfoFirstIdentTime
@userId        NUMERIC(12,0)
AS

BEGIN
	SELECT username,gender,birthdate,email,firstidentitytime as timestamp, localePref
	FROM user_info
	WHERE user_id = @userId

	RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_getUserInfoFirstIdentTime TO web
go
IF OBJECT_ID('dbo.wsp_getUserInfoFirstIdentTime') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserInfoFirstIdentTime >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserInfoFirstIdentTime >>>'
go
EXEC sp_procxmode 'dbo.wsp_getUserInfoFirstIdentTime','unchained'
go
