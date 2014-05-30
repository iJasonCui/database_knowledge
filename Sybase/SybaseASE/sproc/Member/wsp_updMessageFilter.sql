IF OBJECT_ID('dbo.wsp_updMessageFilter') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updMessageFilter
    IF OBJECT_ID('dbo.wsp_updMessageFilter') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updMessageFilter >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updMessageFilter >>>'
END
go

/***********************************************************************
**
** CREATION:
**   Author:        Andy Tran
**   Date:          August 2011
**   Description:   Creates/Updates MessageFilter record
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*************************************************************************/

CREATE PROCEDURE  wsp_updMessageFilter
 @userId       NUMERIC(12,0)
,@filterParams VARCHAR(255)
,@dateExpiry   DATETIME
AS

DECLARE
 @return       INT
,@dateNow      DATETIME

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN TRAN TRAN_updMessageFilter

    IF NOT EXISTS (SELECT 1 FROM MessageFilter WHERE userId = @userId)
        BEGIN
            INSERT INTO MessageFilter (
                 userId
                ,filterParams
                ,status
                ,dateExpiry
                ,dateCreated
                ,dateModified
            )
            VALUES (
                 @userId
                ,@filterParams
                ,'A' -- Active when created
                ,@dateExpiry
                ,@dateNow
                ,@dateNow
            )

            IF @@error != 0
                BEGIN
                    ROLLBACK TRAN TRAN_updMessageFilter
                    RETURN 99
                END

            COMMIT TRAN TRAN_updMessageFilter
            RETURN 0
        END
    ELSE
        BEGIN
            UPDATE MessageFilter
               SET filterParams = @filterParams
                  ,dateExpiry = @dateExpiry
                  ,dateModified = @dateNow
             WHERE userId = @userId

            IF @@error != 0
                BEGIN
                    ROLLBACK TRAN TRAN_updMessageFilter
                    RETURN 98
                END

            COMMIT TRAN TRAN_updMessageFilter
            RETURN 0
        END
go

IF OBJECT_ID('dbo.wsp_updMessageFilter') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updMessageFilter >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updMessageFilter >>>'
go

EXEC sp_procxmode 'dbo.wsp_updMessageFilter','unchained'
go

GRANT EXECUTE ON dbo.wsp_updMessageFilter TO web
go
