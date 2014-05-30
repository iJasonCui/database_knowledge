IF OBJECT_ID('dbo.wsp_getSmileReceived') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getSmileReceived
    IF OBJECT_ID('dbo.wsp_getSmileReceived') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getSmileReceived >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getSmileReceived >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:  Yan Liu 
**   Date:  March 15 2007  
**   Description:  retrieves list of smiles received (Paginate)
**          
** REVISION(S):
**   Author: 
**   Date: 
**   Description: 
**
******************************************************************************/
CREATE PROCEDURE wsp_getSmileReceived
    @rowCount   INT,
    @userId     NUMERIC(12, 0),
    @dateCutoff DATETIME,
    @prevLaston INT 
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
     WHERE p.user_id = s.userId
       AND s.targetUserId = @userId
       AND (p.show_prefs BETWEEN "A" AND "Z")
       AND s.seen != 'T'
       AND s.dateCreated <= @dateCutoff
       AND p.laston >= @prevLaston
    ORDER BY s.dateCreated DESC, p.user_id
    AT ISOLATION READ UNCOMMITTED

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getSmileReceived TO web
go

IF OBJECT_ID('dbo.wsp_getSmileReceived') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getSmileReceived >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getSmileReceived >>>'
go

EXEC sp_procxmode 'dbo.wsp_getSmileReceived','unchained'
go
