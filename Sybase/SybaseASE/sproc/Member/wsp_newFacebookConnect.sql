IF OBJECT_ID('dbo.wsp_newFacebookConnect') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newFacebookConnect
    IF OBJECT_ID('dbo.wsp_newFacebookConnect') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newFacebookConnect >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newFacebookConnect >>>'
END
go

/***********************************************************************
**
** CREATION:
**   Author:        Andy Tran
**   Date:          January, 2011
**   Description:   Creates new FacebookConnect record.
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*************************************************************************/

CREATE PROCEDURE  wsp_newFacebookConnect
 @fbUserId  VARCHAR(24)
,@llUserId  NUMERIC(12,0)
AS

DECLARE
 @return             INT
,@dateNow            DATETIME

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN TRAN TRAN_newFacebookConnect_d
    UPDATE FacebookConnect SET status = 'I', dateModified = @dateNow WHERE llUserId = @llUserId
    UPDATE FacebookConnect SET status = 'I', dateModified = @dateNow WHERE fbUserId = @fbUserId

    IF @@error != 0
        BEGIN
            ROLLBACK TRAN TRAN_newFacebookConnect_d
            RETURN 97
        END
COMMIT TRAN TRAN_newFacebookConnect_d

-- case facebook connect record is not present
IF NOT EXISTS (SELECT 1 FROM FacebookConnect WHERE fbUserId = @fbUserId AND llUserId = @llUserId)
    BEGIN
        BEGIN TRAN TRAN_newFacebookConnect_i
            INSERT INTO FacebookConnect (
                 fbUserId
                ,llUserId
                ,status
                ,dateCreated
                ,dateModified
            )
            VALUES (
                 @fbUserId
                ,@llUserId
                ,'A'
                ,@dateNow
                ,@dateNow
            )

            IF @@error != 0
                BEGIN
                    ROLLBACK TRAN TRAN_newFacebookConnect_i
                    RETURN 99
                END

            COMMIT TRAN TRAN_newFacebookConnect_i
            RETURN 0
    END
ELSE
    BEGIN
        BEGIN TRAN TRAN_newFacebookConnect_u
            UPDATE FacebookConnect
               SET status = 'A',
                   dateModified = @dateNow
             WHERE fbUserId = @fbUserId AND llUserId = @llUserId

            IF @@error != 0
                BEGIN
                    ROLLBACK TRAN TRAN_newFacebookConnect_u
                    RETURN 98
                END

            COMMIT TRAN TRAN_newFacebookConnect_u
            RETURN 0
    END

go
EXEC sp_procxmode 'dbo.wsp_newFacebookConnect','unchained'
go
IF OBJECT_ID('dbo.wsp_newFacebookConnect') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newFacebookConnect >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newFacebookConnect >>>'
go
GRANT EXECUTE ON dbo.wsp_newFacebookConnect TO web
go

