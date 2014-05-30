IF OBJECT_ID('dbo.wsp_getVoiceWaitResponse') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getVoiceWaitResponse
    IF OBJECT_ID('dbo.wsp_getVoiceWaitResponse') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getVoiceWaitResponse >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getVoiceWaitResponse >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:       Frank Qi
**   Date:         June 2010
**   Description:  Get waiting response voice call(s)
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_getVoiceWaitResponse
 @userId NUMERIC(12,0),
 @targetUserId NUMERIC(12,0),
 @product    CHAR(1),
 @community    CHAR(1),
 @timeOut int
AS

BEGIN

    declare @gmt datetime
    exec wsp_GetDateGMT  @gmt OUTPUT
    
    SELECT dateCreated
      FROM VoiceConnect
     WHERE userId = @userId 
       AND targetUserId = @targetUserId
       AND targetPhoneNumber IS NULL
       AND rejectReason IS NULL
        AND product = @product
       AND community = @community
       AND dateCreated >= DATEADD(mi, -@timeOut, @gmt)
    ORDER BY dateCreated DESC
    AT ISOLATION READ UNCOMMITTED

    RETURN @@error
END




go
EXEC sp_procxmode 'dbo.wsp_getVoiceWaitResponse','unchained'
go
IF OBJECT_ID('dbo.wsp_getVoiceWaitResponse') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getVoiceWaitResponse >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getVoiceWaitResponse >>>'
go
GRANT EXECUTE ON dbo.wsp_getVoiceWaitResponse TO web
go
