IF OBJECT_ID('dbo.wsp_saveTwitterFeed') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveTwitterFeed
    IF OBJECT_ID('dbo.wsp_saveTwitterFeed') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveTwitterFeed >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveTwitterFeed >>>'
END
go

/***********************************************************************
**
** CREATION:
**   Author:        Mark Jaeckle
**   Date:          March, 2011
**   Description:   Creates/update TwitterFeed record, relating a llUserId
*    to a twitterFeedId.
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*************************************************************************/

CREATE PROCEDURE  wsp_saveTwitterFeed
  @llUserId  NUMERIC(12,0)
 ,@twitterFeedId  VARCHAR(24)
 ,@profileFeedEnabled bit
AS

DECLARE
 @return             INT
,@dateNow            DATETIME

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

-- INSERT
IF NOT EXISTS (SELECT 1 FROM TwitterFeed WHERE llUserId = @llUserId)
    BEGIN
        BEGIN TRAN TRAN_saveTwitterFeed
            INSERT INTO TwitterFeed (
                 llUserId
                ,twitterFeedId
                ,profileFeedEnabled
                ,dateCreated
                ,dateModified
            )
            VALUES (
                 @llUserId
                ,@twitterFeedId
                ,@profileFeedEnabled
                ,@dateNow
                ,@dateNow
            )

            IF @@error != 0
                BEGIN
                    ROLLBACK TRAN TRAN_saveTwitterFeed
                    RETURN 99
                END

            COMMIT TRAN TRAN_saveTwitterFeed
            RETURN 0
    END
-- UPDATE
ELSE
    BEGIN
        BEGIN TRAN TRAN_updTwitterFeed
            UPDATE TwitterFeed
               SET twitterFeedId = @twitterFeedId,
                   profileFeedEnabled = @profileFeedEnabled,
                   dateModified = @dateNow
             WHERE llUserId = @llUserId

            IF @@error != 0
                BEGIN
                    ROLLBACK TRAN TRAN_updTwitterFeed
                    RETURN 99
                END

            COMMIT TRAN TRAN_updTwitterFeed
            RETURN 0
    END
go

IF OBJECT_ID('dbo.wsp_saveTwitterFeed') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_saveTwitterFeed >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveTwitterFeed >>>'
go

EXEC sp_procxmode 'dbo.wsp_saveTwitterFeed','unchained'
go

GRANT EXECUTE ON dbo.wsp_saveTwitterFeed TO web
go
