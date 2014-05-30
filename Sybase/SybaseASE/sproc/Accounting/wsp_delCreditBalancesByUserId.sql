IF OBJECT_ID('dbo.wsp_delCreditBalancesByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_delCreditBalancesByUserId
    IF OBJECT_ID('dbo.wsp_delCreditBalancesByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_delCreditBalancesByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_delCreditBalancesByUserId >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Sept 10, 2003
**   Description:  delete all Creditbalance rows for user, used when user deleted
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_delCreditBalancesByUserId
@userId NUMERIC(12,0)

AS


BEGIN TRAN TRAN_delCreditBalancesByUserId


	DELETE FROM CreditBalance WHERE userId = @userId

	IF @@error != 0
	BEGIN
		ROLLBACK TRAN TRAN_delCreditBalancesByUserId
		RETURN 99
	END
        ELSE
        BEGIN
                COMMIT TRAN TRAN_delCreditBalancesByUserId
                RETURN 0
        END
go
IF OBJECT_ID('dbo.wsp_delCreditBalancesByUserId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_delCreditBalancesByUserId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_delCreditBalancesByUserId >>>'
go
GRANT EXECUTE ON dbo.wsp_delCreditBalancesByUserId TO web
go

