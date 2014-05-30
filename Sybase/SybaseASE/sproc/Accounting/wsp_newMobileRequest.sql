IF OBJECT_ID('dbo.wsp_newMobileRequest') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newMobileRequest
    IF OBJECT_ID('dbo.wsp_newMobileRequest') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newMobileRequest >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newMobileRequest >>>'
END
go


CREATE PROCEDURE wsp_newMobileRequest
 @userId       NUMERIC(12,0)
,@xactionId    NUMERIC(12,0)
,@totalAmount  VARCHAR(7)
,@phoneNumber  CHAR(20)
,@billingLocationId int 
AS

DECLARE
 @dateNow DATETIME
,@return  INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN TRAN TRAN_newMobileRequest
    INSERT INTO MobilePaymentRequest (
         xactionId
        ,userId
        ,totalAmount
        ,billingLocationId
        ,phoneNumber
        ,dateCreated
    )
    VALUES (
         @xactionId
        ,@userId
        ,@totalAmount
        ,@billingLocationId
        ,@phoneNumber
        ,@dateNow
    )

    IF @@error != 0
        BEGIN
            ROLLBACK TRAN TRAN_newMobileRequest
            RETURN 99
        END

    COMMIT TRAN TRAN_newMobileRequest
    RETURN 0
go

GRANT EXECUTE ON dbo.wsp_newMobileRequest TO web
go

IF OBJECT_ID('dbo.wsp_newMobileRequest') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newMobileRequest >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newMobileRequest >>>'
go

EXEC sp_procxmode 'dbo.wsp_newMobileRequest','unchained'
go
