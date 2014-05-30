IF OBJECT_ID('dbo.wsp_getPassReceived') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getPassReceived
    IF OBJECT_ID('dbo.wsp_getPassReceived') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getPassReceived >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getPassReceived >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:  Yan Liu 
**   Date:  March 15 2007  
**   Description:  retrieves list of passes received (Paginate)
**          
** REVISION(S):
**   Author: 
**   Date: 
**   Description: 
**
******************************************************************************/
CREATE PROCEDURE wsp_getPassReceived
    @rowCount     INT,
    @userId       NUMERIC(12, 0),
    @dateCutoff   DATETIME,
    @prevLaston   INT
AS

BEGIN
    SET ROWCOUNT @rowCount
    SELECT p.user_id,
           p.myidentity,
           p.on_line, 
           s.seen, 
           s.dateCreated 
      FROM a_profile_dating p, Pass s
     WHERE p.user_id = s.userId
       AND s.targetUserId = @userId
       AND s.seen != 'T'
       AND ISNULL(s.messageOnHoldStatus,'A') != 'H'
       AND (p.show_prefs BETWEEN "A" AND "Z")
       AND s.dateCreated <= @dateCutoff 
       AND p.laston >= @prevLaston 
    ORDER BY s.dateCreated DESC, p.user_id
    AT ISOLATION READ UNCOMMITTED

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getPassReceived TO web
go

IF OBJECT_ID('dbo.wsp_getPassReceived') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getPassReceived >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getPassReceived >>>'
go

EXEC sp_procxmode 'dbo.wsp_getPassReceived','unchained'
go
