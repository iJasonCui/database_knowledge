IF OBJECT_ID('dbo.wsp_PayPalBatchId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_PayPalBatchId
    IF OBJECT_ID('dbo.wsp_PayPalBatchId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_PayPalBatchId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_PayPalBatchId >>>'
END
go

/******************************************************************************
 **
 ** CREATION:
 **   Author:       Andy Tran
 **   Date:         October 12 2005
 **   Description:  Generation of PayPalBatchId
 **
 ** REVISION(S):
 **   Author:
 **   Date:
 **   Description:
 **
 ******************************************************************************/
CREATE PROCEDURE wsp_PayPalBatchId @batchId INT OUTPUT
AS
DECLARE
 @return          INT
,@dateGMT         DATETIME

EXEC @return = dbo.wsp_GetDateGMT @dateGMT OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN TRAN TRAN_wsp_PayPalBatchId
    UPDATE PayPalBatchId
    SET BatchId = BatchId + 1

    IF @@error = 0
        BEGIN
            SELECT @batchId = BatchId FROM PayPalBatchId
            INSERT INTO PayPalBatchIdLog VALUES (@batchId, @dateGMT)
            IF @@error = 0
                BEGIN
                    COMMIT TRAN TRAN_wsp_PayPalBatchId
                    RETURN 0
                END
            ELSE
                BEGIN
                    ROLLBACK TRAN TRAN_wsp_PayPalBatchId
                    RETURN 99
                END
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_wsp_PayPalBatchId
            RETURN 98
        END
go

GRANT EXECUTE ON dbo.wsp_PayPalBatchId TO web
go

IF OBJECT_ID('dbo.wsp_PayPalBatchId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_PayPalBatchId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_PayPalBatchId >>>'
go
