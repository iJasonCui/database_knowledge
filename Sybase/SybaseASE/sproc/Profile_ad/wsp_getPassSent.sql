IF OBJECT_ID('dbo.wsp_getPassSent') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getPassSent
    IF OBJECT_ID('dbo.wsp_getPassSent') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getPassSent >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getPassSent >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:  Yan Liu 
**   Date:  March 15 2007  
**   Description:  retrieves list of passes sent (Paginate)
**          
** REVISION(S):
**   Author: 
**   Date: 
**   Description: 
**
******************************************************************************/
CREATE PROCEDURE wsp_getPassSent
    @rowCount   INT,
    @userId     NUMERIC(12, 0),
    @dateCutoff DATETIME
AS

BEGIN
    SET ROWCOUNT @rowCount
    SELECT p.user_id,
           p.myidentity,
           p.on_line, 
           s.seen, 
           s.dateCreated 
      FROM a_profile_dating p, Pass s
     WHERE p.user_id = s.targetUserId
       AND s.userId = @userId
       AND (p.show_prefs BETWEEN "A" AND "Z")
       AND s.dateCreated <= @dateCutoff 
    ORDER BY s.dateCreated DESC, p.user_id
    AT ISOLATION READ UNCOMMITTED

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getPassSent TO web
go

IF OBJECT_ID('dbo.wsp_getPassSent') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getPassSent >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getPassSent >>>'
go

EXEC sp_procxmode 'dbo.wsp_getPassSent','unchained'
go
