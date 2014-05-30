IF OBJECT_ID('dbo.wsp_getSmileSent') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getSmileSent
    IF OBJECT_ID('dbo.wsp_getSmileSent') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getSmileSent >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getSmileSent >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:  Yan Liu 
**   Date:  March 15 2007  
**   Description:  retrieves list of smiles sent (Paginate)
**          
** REVISION(S):
**   Author: 
**   Date: 
**   Description: 
**
******************************************************************************/
CREATE PROCEDURE wsp_getSmileSent
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
           s.smileNoteId1, 
           s.smileNoteId2,
           s.dateCreated 
      FROM a_profile_dating p, Smile s
     WHERE p.user_id = s.targetUserId
       AND s.userId = @userId
       AND (p.show_prefs BETWEEN "A" AND "Z")
       AND s.dateCreated <= @dateCutoff 
    ORDER BY s.dateCreated DESC, p.user_id
    AT ISOLATION READ UNCOMMITTED

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getSmileSent TO web
go

IF OBJECT_ID('dbo.wsp_getSmileSent') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getSmileSent >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getSmileSent >>>'
go

EXEC sp_procxmode 'dbo.wsp_getSmileSent','unchained'
go
