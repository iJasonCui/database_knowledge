IF OBJECT_ID('dbo.wsp_newSDAccount') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newSDAccount
    IF OBJECT_ID('dbo.wsp_newSDAccount') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newSDAccount >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newSDAccount >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         June 1, 2009
**   Description:  Record new SD account
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_newSDAccount
 @userId             NUMERIC(12,0)
,@billingLocationId  SMALLINT

AS
DECLARE
 @return       INT
,@passOfferId  SMALLINT
,@dateNow      DATETIME
,@dateExpiry   DATETIME

-- get @dateNow
EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
    BEGIN
        RETURN 99
    END

SELECT @passOfferId = defaultPassOfferId FROM SDDefaultAccount WHERE billingLocationId = @billingLocationId
IF @passOfferId <= 0
    BEGIN
        RETURN 98
    END

SELECT @dateExpiry = 'December 31 2052'

BEGIN TRAN TRAN_newSDAccount
    INSERT INTO SDAccount (
         userId
        ,passOfferId
        ,dateCreated
        ,dateModified
        ,dateExpiry
    ) VALUES (
         @userId
        ,@passOfferId
        ,@dateNow
        ,@dateNow
        ,@dateExpiry
    )

    IF @@error != 0
        BEGIN
            ROLLBACK TRAN TRAN_newSDAccount
            RETURN 97
        END

    COMMIT TRAN TRAN_newSDAccount
    RETURN 0
go

IF OBJECT_ID('dbo.wsp_newSDAccount') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newSDAccount >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newSDAccount >>>'
go

GRANT EXECUTE ON dbo.wsp_newSDAccount TO web
go
