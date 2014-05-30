IF OBJECT_ID('dbo.wsp_updPurchaseUserIP') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updPurchaseUserIP
    IF OBJECT_ID('dbo.wsp_updPurchaseUserIP') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updPurchaseUserIP >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updupdPurchaseUserIP >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         Aug 2006
**   Description:  Update userIP in Purchase table
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_updPurchaseUserIP
 @xactionId   NUMERIC(12,0)
,@userIP      NUMERIC(12,0)
AS

BEGIN TRAN TRAN_updPurchaseUserIP
    UPDATE Purchase
    SET userIP = @userIP
    WHERE xactionId = @xactionId
            
    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_updPurchaseUserIP
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_updPurchaseUserIP
            RETURN 99
        END
go

IF OBJECT_ID('dbo.wsp_updPurchaseUserIP') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updPurchaseUserIP >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updupdPurchaseUserIP >>>'
go

GRANT EXECUTE ON dbo.wsp_updPurchaseUserIP TO web
go
