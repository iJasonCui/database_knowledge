IF OBJECT_ID('dbo.wsp_getUserInfoUnvrsIdByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserInfoUnvrsIdByUserId
    IF OBJECT_ID('dbo.wsp_getUserInfoUnvrsIdByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserInfoUnvrsIdByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserInfoUnvrsIdByUserId >>>'
END
go
 /***********************************************************************
**
** CREATION:
**   Author:  Francisc Schonberger
**   Date:  January 9 2003
**   Description:  Retrieves Universal Id and Universal Password (900) 
**                 for a given user id
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*************************************************************************/

CREATE PROCEDURE  dbo.wsp_getUserInfoUnvrsIdByUserId
@userId NUMERIC(12,0)
AS

BEGIN
	SELECT universal_id,universal_password 
	FROM user_info
	WHERE user_id = @userId

	RETURN @@error
END
 
go
GRANT EXECUTE ON dbo.wsp_getUserInfoUnvrsIdByUserId TO web
go
IF OBJECT_ID('dbo.wsp_getUserInfoUnvrsIdByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserInfoUnvrsIdByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserInfoUnvrsIdByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_getUserInfoUnvrsIdByUserId','unchained'
go
