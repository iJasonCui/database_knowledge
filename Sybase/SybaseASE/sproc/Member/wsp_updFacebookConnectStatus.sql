IF OBJECT_ID('dbo.wsp_updFacebookConnectStatus') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updFacebookConnectStatus
    IF OBJECT_ID('dbo.wsp_updFacebookConnectStatus') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updFacebookConnectStatus >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updFacebookConnectStatus >>>'
END
go

/***********************************************************************
**
** CREATION:
**   Author:        Andy Tran
**   Date:          January, 2011
**   Description:   Updates the status of a FacebookConnect record.
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*************************************************************************/

CREATE PROCEDURE  wsp_updFacebookConnectStatus
 @fbUserId  VARCHAR(24)
,@llUserId  NUMERIC(12,0)
,@status    CHAR(1)
AS

DECLARE
 @return             INT
,@dateNow            DATETIME

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

IF EXISTS (SELECT 1 FROM FacebookConnect WHERE fbUserId = @fbUserId AND llUserId = @llUserId)
    BEGIN
        BEGIN TRAN TRAN_updFacebookConnectStatus
            UPDATE FacebookConnect
               SET status = @status,
                   dateModified = @dateNow
             WHERE fbUserId = @fbUserId
               AND llUserId = @llUserId

            IF @@error != 0
                BEGIN
                    ROLLBACK TRAN TRAN_updFacebookConnectStatus
                    RETURN 99
                END

            COMMIT TRAN TRAN_updFacebookConnectStatus
            RETURN 0
    END
go

IF OBJECT_ID('dbo.wsp_updFacebookConnectStatus') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updFacebookConnectStatus >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updFacebookConnectStatus >>>'
go

EXEC sp_procxmode 'dbo.wsp_updFacebookConnectStatus','unchained'
go

GRANT EXECUTE ON dbo.wsp_updFacebookConnectStatus TO web
go
