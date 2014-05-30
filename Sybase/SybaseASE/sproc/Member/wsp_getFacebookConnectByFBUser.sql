IF OBJECT_ID('dbo.wsp_getFacebookConnectByFBUser') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getFacebookConnectByFBUser
    IF OBJECT_ID('dbo.wsp_getFacebookConnectByFBUser') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getFacebookConnectByFBUser >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getFacebookConnectByFBUser >>>'
END
go

/***********************************************************************
**
** CREATION:
**   Author:        Andy Tran
**   Date:          January, 2011
**   Description:   Gets FacebookConnect record by Facebook userId.
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*************************************************************************/

CREATE PROCEDURE  wsp_getFacebookConnectByFBUser
 @fbUserId  VARCHAR(24)
AS

BEGIN
    SELECT llUserId
      FROM FacebookConnect
     WHERE fbUserId = @fbUserId
       AND status = 'A'

    RETURN @@error
END
go

IF OBJECT_ID('dbo.wsp_getFacebookConnectByFBUser') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getFacebookConnectByFBUser >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getFacebookConnectByFBUser >>>'
go

EXEC sp_procxmode 'dbo.wsp_getFacebookConnectByFBUser','unchained'
go

GRANT EXECUTE ON dbo.wsp_getFacebookConnectByFBUser TO web
go
