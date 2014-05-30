IF OBJECT_ID('dbo.wsp_getFacebookConnectByLLUser') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getFacebookConnectByLLUser
    IF OBJECT_ID('dbo.wsp_getFacebookConnectByLLUser') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getFacebookConnectByLLUser >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getFacebookConnectByLLUser >>>'
END
go

/***********************************************************************
**
** CREATION:
**   Author:        Andy Tran
**   Date:          January, 2011
**   Description:   Gets FacebookConnect record by Lavalife userId.
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*************************************************************************/

CREATE PROCEDURE  wsp_getFacebookConnectByLLUser
 @llUserId  NUMERIC(12,0)
AS

BEGIN
    SELECT fbUserId
      FROM FacebookConnect
     WHERE llUserId = @llUserId
       AND status = 'A'

    RETURN @@error
END
go

IF OBJECT_ID('dbo.wsp_getFacebookConnectByLLUser') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getFacebookConnectByLLUser >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getFacebookConnectByLLUser >>>'
go

EXEC sp_procxmode 'dbo.wsp_getFacebookConnectByLLUser','unchained'
go

GRANT EXECUTE ON dbo.wsp_getFacebookConnectByLLUser TO web
go
