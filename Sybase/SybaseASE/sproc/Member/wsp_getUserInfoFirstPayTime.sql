IF OBJECT_ID('dbo.wsp_getUserInfoFirstPayTime') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserInfoFirstPayTime
    IF OBJECT_ID('dbo.wsp_getUserInfoFirstPayTime') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserInfoFirstPayTime >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserInfoFirstPayTime >>>'
END
go
/***********************************************************************
**
** CREATION:
**   Author:  Yan Liu/jack Veiga
**   Date:  Septerber 2003
**   Description:  Retrieves firstpaytime, etc for a given user id
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*************************************************************************/

CREATE PROCEDURE dbo.wsp_getUserInfoFirstPayTime
@userId  NUMERIC(12,0)
AS

BEGIN
	SELECT firstpaytime
	FROM user_info
	WHERE user_id = @userId

	RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_getUserInfoFirstPayTime TO web
go
IF OBJECT_ID('dbo.wsp_getUserInfoFirstPayTime') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserInfoFirstPayTime >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserInfoFirstPayTime >>>'
go
EXEC sp_procxmode 'dbo.wsp_getUserInfoFirstPayTime','unchained'
go
