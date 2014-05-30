IF OBJECT_ID('dbo.wsp_getUserTypeByUserName') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserTypeByUserName
    IF OBJECT_ID('dbo.wsp_getUserTypeByUserName') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserTypeByUserName >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserTypeByUserName >>>'
END
go

/***********************************************************************
**
** CREATION:
**   Author:  Anna Deigin
**   Date:  May 18 2005
**   Description:  Retrieves user status for a given user name
**
** REVISION(S):
**   Author:  Andy Tran
**   Date:  Jul 30 2008
**   Description:  use email address as username
**
*************************************************************************/
CREATE PROCEDURE  wsp_getUserTypeByUserName
 @username VARCHAR(129)
AS
SELECT @username = UPPER(@username)

BEGIN
    IF NOT EXISTS (SELECT 1 FROM user_info WHERE username = @username AND user_type NOT IN ('S','A','D','B'))
        BEGIN
            SELECT @username = username FROM user_info WHERE email = @username AND user_type NOT IN ('S','A','D','B')
        END 

    SELECT user_type
      FROM user_info
     WHERE username = @username
       AND user_type NOT IN ('S','A','D','B')

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getUserTypeByUserName TO web
go

IF OBJECT_ID('dbo.wsp_getUserTypeByUserName') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserTypeByUserName >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserInfoByUserName >>>'
go

EXEC sp_procxmode 'dbo.wsp_getUserTypeByUserName','unchained'
go

GRANT EXECUTE ON dbo.wsp_getUserTypeByUserName TO web
go
