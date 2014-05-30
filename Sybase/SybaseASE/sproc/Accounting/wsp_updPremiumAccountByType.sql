IF OBJECT_ID('dbo.wsp_updPremiumAccountByType') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updPremiumAccountByType
    IF OBJECT_ID('dbo.wsp_updPremiumAccountByType') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updPremiumAccountByType >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updPremiumAccountByType >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         Nov 7, 2005
**   Description:  Update PremiumAccount for user
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_updPremiumAccountByType
 @userId               NUMERIC(12,0)
,@premiumAccountTypeId SMALLINT
,@duration             SMALLINT
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

BEGIN TRAN TRAN_updPremiumAccountByType
    IF EXISTS (SELECT 1 FROM PremiumAccount WHERE userId = @userId AND premiumAccountTypeId = @premiumAccountTypeId)
        BEGIN
            SELECT @dateExpiry = (SELECT dateExpiry FROM PremiumAccount WHERE userId = @userId AND premiumAccountTypeId = @premiumAccountTypeId)
            UPDATE PremiumAccount
               SET dateExpiry = (SELECT dateadd(dd, @duration, @dateExpiry)),
                   dateModified = @dateNow
             WHERE userId = @userId
               AND premiumAccountTypeId = @premiumAccountTypeId
            
            IF @@error = 0
                BEGIN
                    COMMIT TRAN TRAN_updPremiumAccountByType
                    RETURN 0
                END
            ELSE
                BEGIN
                    ROLLBACK TRAN TRAN_updPremiumAccountByType
                    RETURN 98
                END
        END
    ELSE
        BEGIN
            SELECT @dateExpiry = (SELECT dateadd(dd, @duration, @dateNow))
            INSERT INTO PremiumAccount
            (
                 userId
                ,premiumAccountTypeId
                ,dateExpiry
                ,dateModified
                ,dateCreated
            )
            VALUES
            (
                 @userId
                ,@premiumAccountTypeId
                ,@dateExpiry
                ,@dateNow
                ,@dateNow
            )
            
            IF @@error = 0
                BEGIN
                    COMMIT TRAN TRAN_updPremiumAccountByType
                    RETURN 0
                END
            ELSE
                BEGIN
                    ROLLBACK TRAN TRAN_updPremiumAccountByType
                    RETURN 97
                END
        END
go

IF OBJECT_ID('dbo.wsp_updPremiumAccountByType') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updPremiumAccountByType >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updupdPremiumAccountByType >>>'
go

GRANT EXECUTE ON dbo.wsp_updPremiumAccountByType TO web
go
