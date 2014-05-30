IF OBJECT_ID('dbo.wsp_updCCTranRenewalFlag') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updCCTranRenewalFlag
    IF OBJECT_ID('dbo.wsp_updCCTranRenewalFlag') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updCCTranRenewalFlag >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updCCTranRenewalFlag >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         June 23, 2008
**   Description:  Update renewalFlag on CreditCardTransaction
**                 for the given xactionId.
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_updCCTranRenewalFlag
 @xactionId NUMERIC(12,0)
AS

IF EXISTS (SELECT 1 FROM CreditCardTransaction WHERE xactionId = @xactionId)
    BEGIN
        BEGIN TRAN TRAN_updCCTranRenewalFlag
            UPDATE CreditCardTransaction
               SET renewalFlag = 'Y'
             WHERE xactionId = @xactionId

            IF @@error = 0
                BEGIN
                    COMMIT TRAN TRAN_updCCTranRenewalFlag
                    RETURN 0
                END
            ELSE
                BEGIN
                    ROLLBACK TRAN TRAN_updCCTranRenewalFlag
                    RETURN 99
                END
    END
go

GRANT EXECUTE ON dbo.wsp_updCCTranRenewalFlag TO web
go

IF OBJECT_ID('dbo.wsp_updCCTranRenewalFlag') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updCCTranRenewalFlag >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updCCTranRenewalFlag >>>'
go

EXEC sp_procxmode 'dbo.wsp_updCCTranRenewalFlag','unchained'
go
