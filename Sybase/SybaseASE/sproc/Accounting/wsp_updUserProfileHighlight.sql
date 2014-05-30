IF OBJECT_ID('dbo.wsp_updUserProfileHighlight') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updUserProfileHighlight
    IF OBJECT_ID('dbo.wsp_updUserProfileHighlight') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updUserProfileHighlight >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updupdUserProfileHighlight >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         Nov 7, 2005
**   Description:  Update UserProfileHighlight for user
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_updUserProfileHighlight
 @userId   NUMERIC(12,0)
,@duration SMALLINT
AS

DECLARE
 @return     INT
,@dateNow    DATETIME
,@dateExpiry DATETIME

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN TRAN TRAN_updUserProfileHighlight
    IF EXISTS (SELECT 1 FROM UserProfileHighlight WHERE userId = @userId)
        BEGIN
            SELECT @dateExpiry = (SELECT dateExpiry FROM UserProfileHighlight WHERE userId = @userId)
            UPDATE UserProfileHighlight
               SET dateExpiry = (SELECT dateadd(dd, @duration, @dateExpiry)),
                   dateModified = @dateNow
             WHERE userId = @userId
            
            IF @@error = 0
                BEGIN
                    COMMIT TRAN TRAN_updUserProfileHighlight
                    RETURN 0
                END
            ELSE
                BEGIN
                    ROLLBACK TRAN TRAN_updUserProfileHighlight
                    RETURN 98
                END
        END
    ELSE
        BEGIN
            SELECT @dateExpiry = (SELECT dateadd(dd, @duration, @dateNow))
            INSERT INTO UserProfileHighlight
            (
                 userId
                ,dateExpiry
                ,dateModified
                ,dateCreated
            )
            VALUES
            (
                 @userId
                ,@dateExpiry
                ,@dateNow
                ,@dateNow
            )
            
            IF @@error = 0
                BEGIN
                    COMMIT TRAN TRAN_updUserProfileHighlight
                    RETURN 0
                END
            ELSE
                BEGIN
                    ROLLBACK TRAN TRAN_updUserProfileHighlight
                    RETURN 97
                END
        END
go

IF OBJECT_ID('dbo.wsp_updUserProfileHighlight') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updUserProfileHighlight >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updupdUserProfileHighlight >>>'
go

GRANT EXECUTE ON dbo.wsp_updUserProfileHighlight TO web
go
