IF OBJECT_ID('dbo.wsp_deleteTwitterFeed') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_deleteTwitterFeed
    IF OBJECT_ID('dbo.wsp_deleteTwitterFeed') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_deleteTwitterFeed >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_deleteTwitterFeed >>>'
END
go

/***********************************************************************
**
** CREATION:
**   Author:        Mark Jaeckle
**   Date:          March, 2011
**   Description:   Deletes TwitterFeed record
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*************************************************************************/

CREATE PROCEDURE  wsp_deleteTwitterFeed
  @llUserId  NUMERIC(12,0)
AS

DECLARE
 @return             INT
,@dateNow            DATETIME

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

IF EXISTS (SELECT 1 FROM TwitterFeed WHERE llUserId = @llUserId)
    BEGIN
        BEGIN TRAN TRAN_deleteTwitterFeed
            DELETE FROM TwitterFeed
            WHERE llUserId = @llUserId

            IF @@error != 0
                BEGIN
                    ROLLBACK TRAN TRAN_deleteTwitterFeed
                    RETURN 99
                END

            COMMIT TRAN TRAN_deleteTwitterFeed
            RETURN 0
    END
go

IF OBJECT_ID('dbo.wsp_deleteTwitterFeed') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_deleteTwitterFeed >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_deleteTwitterFeed >>>'
go

EXEC sp_procxmode 'dbo.wsp_deleteTwitterFeed','unchained'
go

GRANT EXECUTE ON dbo.wsp_deleteTwitterFeed TO web
go
