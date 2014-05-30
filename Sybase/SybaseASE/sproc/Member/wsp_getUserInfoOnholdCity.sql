IF OBJECT_ID('dbo.wsp_getUserInfoOnholdCity') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserInfoOnholdCity
    IF OBJECT_ID('dbo.wsp_getUserInfoOnholdCity') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserInfoOnholdCity >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserInfoOnholdCity >>>'
END
go
  /***********************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  June 6, 2002
**   Description:  Retrieves onhold city, etc for a given user id
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*************************************************************************/

CREATE PROCEDURE  wsp_getUserInfoOnholdCity
@userId        NUMERIC(12,0)
AS

BEGIN
	SELECT username,gender,birthdate,email,onhold_city as onhold
	FROM user_info
	WHERE user_id = @userId

	RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_getUserInfoOnholdCity TO web
go
IF OBJECT_ID('dbo.wsp_getUserInfoOnholdCity') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserInfoOnholdCity >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserInfoOnholdCity >>>'
go
EXEC sp_procxmode 'dbo.wsp_getUserInfoOnholdCity','unchained'
go
