IF OBJECT_ID('dbo.wsp_getTwitterFeedByLLUser') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getTwitterFeedByLLUser
    IF OBJECT_ID('dbo.wsp_getTwitterFeedByLLUser') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getTwitterFeedByLLUser >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getTwitterFeedByLLUser >>>'
END
go

/***********************************************************************
**
** CREATION:
**   Author:        Mark Jaeckle
**   Date:          March, 2011
**   Description:   Gets TwitterFeed record by Lavalife userId.
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*************************************************************************/

CREATE PROCEDURE  wsp_getTwitterFeedByLLUser
 @llUserId  NUMERIC(12,0)
AS

BEGIN
    SELECT twitterFeedId
           ,profileFeedEnabled
      FROM TwitterFeed
     WHERE llUserId = @llUserId

    RETURN @@error
END
go

IF OBJECT_ID('dbo.wsp_getTwitterFeedByLLUser') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getTwitterFeedByLLUser >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getTwitterFeedByLLUser >>>'
go

EXEC sp_procxmode 'dbo.wsp_getTwitterFeedByLLUser','unchained'
go

GRANT EXECUTE ON dbo.wsp_getTwitterFeedByLLUser TO web
go
