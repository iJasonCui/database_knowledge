IF OBJECT_ID('dbo.wsp_newMobileResponse') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newMobileResponse
    IF OBJECT_ID('dbo.wsp_newMobileResponse') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newMobileResponse >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newMobileResponse >>>'
END
go


CREATE PROCEDURE wsp_newMobileResponse
@xactionId    NUMERIC(12,0)
,@billingRequestId NUMERIC(12,0)
,@billingStatusCode int 
AS

DECLARE
 @dateNow DATETIME
,@return  INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN TRAN TRAN_newMobileResponse
    INSERT INTO MobilePaymentResponse (
         xactionId
        ,billingRequestId
        ,billingStatusCode
        ,dateCreated
    )
    VALUES (
         @xactionId
        ,@billingRequestId
        ,@billingStatusCode
        ,@dateNow
    )

    IF @@error != 0
        BEGIN
            ROLLBACK TRAN TRAN_newMobileResponse
            RETURN 99
        END

    COMMIT TRAN TRAN_newMobileResponse
    RETURN 0
go

GRANT EXECUTE ON dbo.wsp_newMobileResponse TO web
go

IF OBJECT_ID('dbo.wsp_newMobileResponse') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newMobileResponse >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newMobileResponse >>>'
go

EXEC sp_procxmode 'dbo.wsp_newMobileResponse','unchained'
go
