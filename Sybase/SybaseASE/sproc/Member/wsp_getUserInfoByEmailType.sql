IF OBJECT_ID('dbo.wsp_getUserInfoByEmailType') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserInfoByEmailType
    IF OBJECT_ID('dbo.wsp_getUserInfoByEmailType') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserInfoByEmailType >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserInfoByEmailType >>>'
END
go
 /***********************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Author:  Jeff Yang 
**   Date:  September 23 2002
**   Description:  Retrieves user info for a given user id
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*************************************************************************/

CREATE PROCEDURE  wsp_getUserInfoByEmailType
@email VARCHAR(129)
AS
SELECT @email = UPPER(@email)

BEGIN
	SELECT username ,password
	FROM   user_info
	WHERE  email = @email and status != 'J' and user_type != 'O'

	RETURN @@error
END
 
go
GRANT EXECUTE ON dbo.wsp_getUserInfoByEmailType TO web
go
IF OBJECT_ID('dbo.wsp_getUserInfoByEmailType') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserInfoByEmailType >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserInfoByEmailType >>>'
go
EXEC sp_procxmode 'dbo.wsp_getUserInfoByEmailType','unchained'
go
