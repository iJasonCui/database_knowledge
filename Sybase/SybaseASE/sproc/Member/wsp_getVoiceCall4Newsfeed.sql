USE Member
go
IF OBJECT_ID('dbo.wsp_getVoiceCall4Newsfeed') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getVoiceCall4Newsfeed
    IF OBJECT_ID('dbo.wsp_getVoiceCall4Newsfeed') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getVoiceCall4Newsfeed >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getVoiceCall4Newsfeed >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         February 2010
**   Description:  Get voice calls by target user and newer than cutoff date
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_getVoiceCall4Newsfeed
 @targetUserId NUMERIC(12,0)
,@community    CHAR(1)
,@cutoff       DATETIME
,@rowcount     SMALLINT
AS

BEGIN
    SET rowcount @rowcount

    SELECT userId
          ,dateCreated
      FROM VoiceConnect
     WHERE targetUserId = @targetUserId
       AND targetUserId != userId
       AND targetPhoneNumber IS NULL
       AND rejectReason = 'OL'
       AND community = @community
       AND dateCreated > @cutoff
    ORDER BY dateCreated DESC
    AT ISOLATION READ UNCOMMITTED

    SET rowcount 0
    RETURN @@error
END
go
EXEC sp_procxmode 'dbo.wsp_getVoiceCall4Newsfeed','unchained'
go
IF OBJECT_ID('dbo.wsp_getVoiceCall4Newsfeed') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getVoiceCall4Newsfeed >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getVoiceCall4Newsfeed >>>'
go
GRANT EXECUTE ON dbo.wsp_getVoiceCall4Newsfeed TO web
go
