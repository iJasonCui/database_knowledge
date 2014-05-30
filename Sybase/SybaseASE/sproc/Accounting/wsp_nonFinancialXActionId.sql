IF OBJECT_ID('dbo.wsp_nonFinancialXActionId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_nonFinancialXActionId
    IF OBJECT_ID('dbo.wsp_nonFinancialXActionId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_nonFinancialXActionId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_nonFinancialXActionId >>>'
END
go

CREATE PROCEDURE wsp_nonFinancialXActionId @returnId INT OUTPUT
AS

BEGIN TRAN TRAN_wsp_nonFinXActionId
    UPDATE NonFinancialXActionId
    SET nonFinancialXActionId = nonFinancialXActionId + 1

    IF @@error = 0
        BEGIN
            SELECT @returnId = nonFinancialXActionId
            FROM NonFinancialXActionId
            COMMIT TRAN TRAN_wsp_nonFinXActionId
		  RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_wsp_nonFinXActionId
		  RETURN 99
        END
go

IF OBJECT_ID('dbo.wsp_nonFinancialXActionId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_nonFinancialXActionId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_nonFinancialXActionId >>>'
go
GRANT EXECUTE ON dbo.wsp_nonFinancialXActionId TO web
go
