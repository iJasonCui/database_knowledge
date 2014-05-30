IF OBJECT_ID('dbo.wsp_cntTotalSmileSent') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntTotalSmileSent
    IF OBJECT_ID('dbo.wsp_cntTotalSmileSent') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntTotalSmileSent >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntTotalSmileSent >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:  Yan Liu 
**   Date:  March 15 2007  
**   Description:  count total smiles sent 
**          
** REVISION(S):
**   Author: 
**   Date: 
**   Description: 
**
******************************************************************************/
CREATE PROCEDURE wsp_cntTotalSmileSent
    @userId NUMERIC(12, 0)
AS

BEGIN
    DECLARE @dateNow DATETIME
    DECLARE @return  INT
    DECLARE @now     INT

    SELECT @dateNow = getdate()
    EXEC @return = wsp_convertTimestamp @dateNow, @now OUTPUT, NULL
    IF (@return != 0)
    BEGIN
        RETURN 99
    END
 
    SELECT COUNT(*) 
      FROM a_profile_dating p, Smile s
     WHERE p.user_id = s.targetUserId
       AND s.userId = @userId
       AND (p.show_prefs BETWEEN "A" AND "Z")
       AND p.laston < @now
    AT ISOLATION READ UNCOMMITTED

    END
go

GRANT EXECUTE ON dbo.wsp_cntTotalSmileSent TO web
go

IF OBJECT_ID('dbo.wsp_cntTotalSmileSent') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_cntTotalSmileSent >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntTotalSmileSent >>>'
go

EXEC sp_procxmode 'dbo.wsp_cntTotalSmileSent','unchained'
go
