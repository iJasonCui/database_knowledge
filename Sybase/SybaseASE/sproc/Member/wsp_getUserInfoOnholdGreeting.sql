IF OBJECT_ID('dbo.wsp_getUserInfoOnholdGreeting') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserInfoOnholdGreeting
    IF OBJECT_ID('dbo.wsp_getUserInfoOnholdGreeting') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserInfoOnholdGreeting >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserInfoOnholdGreeting >>>'
END
go
  /***********************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  June 6, 2002
**   Description:  Retrieves onhold greeting, etc for a given user id
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: June 23, 2004
**   Description: return localePref too
**
*************************************************************************/

CREATE PROCEDURE  wsp_getUserInfoOnholdGreeting
@userId        NUMERIC(12,0)
AS

BEGIN
	SELECT username,gender,birthdate,email,onhold_greeting as onhold, localePref
	FROM user_info
	WHERE user_id = @userId

	RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_getUserInfoOnholdGreeting TO web
go
IF OBJECT_ID('dbo.wsp_getUserInfoOnholdGreeting') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserInfoOnholdGreeting >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserInfoOnholdGreeting >>>'
go
EXEC sp_procxmode 'dbo.wsp_getUserInfoOnholdGreeting','unchained'
go
