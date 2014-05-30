IF OBJECT_ID('dbo.wsp_cntTotalPassSent') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntTotalPassSent
    IF OBJECT_ID('dbo.wsp_cntTotalPassSent') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntTotalPassSent >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntTotalPassSent >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:  Yan Liu 
**   Date:  March 15 2007  
**   Description:  count total passes sent
**          
** REVISION(S):
**   Author: 
**   Date: 
**   Description: 
**
******************************************************************************/
CREATE PROCEDURE wsp_cntTotalPassSent
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
      FROM a_profile_dating p, Pass s
     WHERE p.user_id = s.targetUserId
       AND s.userId = @userId
       AND (p.show_prefs BETWEEN "A" AND "Z")
       AND p.laston < @now
    AT ISOLATION READ UNCOMMITTED

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_cntTotalPassSent TO web
go

IF OBJECT_ID('dbo.wsp_cntTotalPassSent') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_cntTotalPassSent >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntTotalPassSent >>>'
go

EXEC sp_procxmode 'dbo.wsp_cntTotalPassSent','unchained'
go
