IF OBJECT_ID('dbo.p_arcPaymentechResponse') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcPaymentechResponse
   IF OBJECT_ID('dbo.p_arcPaymentechResponse') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcPaymentechResponse >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcPaymentechResponse >>>'
END
go
CREATE procedure dbo.p_arcPaymentechResponse @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..PaymentechResponse
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- PaymentechResponse
DECLARE @xactionId   numeric(12,0)
DECLARE @responseCode	char(3)
DECLARE @responseDate	char(6)
DECLARE @approvalCode	char(6)
DECLARE @avsResponseCode	char(2)
DECLARE @securityResponseCode	char(1)
DECLARE @cardNumber	varchar(64)
DECLARE @cardExpiryMonth	char(2)
DECLARE @cardExpiryYear	char(2)
DECLARE @cardType	char(2)
DECLARE @recurringPaymentCode	char(2)
DECLARE @cavvResponseCode	char(1)
DECLARE @amount   numeric(10,0)
DECLARE @errorMessage	varchar(255)
DECLARE @dateCreated   datetime

/* Declare Local Variable -- auditing purpose */
DECLARE @returnMessage 			varchar(255)
DECLARE @rowCountPassedCheck		int
DECLARE @rowCountArchived		int
DECLARE @rowCountReport			int
DECLARE @dateCreatedFrom		datetime
DECLARE @dateCreatedTo			datetime

/* Initialization */
SELECT @rowCountPassedCheck = 0
SELECT @rowCountArchived    = 0
SELECT @rowCountReport	    = 0

/* Declare cursor on AccountingLoad..PaymentechResponse */
DECLARE cur_PaymentechResponse CURSOR FOR
SELECT 
	@batchId
	,xactionId
	,responseCode
	,responseDate
	,approvalCode
	,avsResponseCode
	,securityResponseCode
	,cardNumber
	,cardExpiryMonth
	,cardExpiryYear
	,cardType
	,recurringPaymentCode
	,cavvResponseCode
	,amount
	,errorMessage
	,dateCreated
FROM PaymentechResponse
FOR READ ONLY

OPEN cur_PaymentechResponse
FETCH cur_PaymentechResponse INTO
	@batchId
	,@xactionId
	,@responseCode
	,@responseDate
	,@approvalCode
	,@avsResponseCode
	,@securityResponseCode
	,@cardNumber
	,@cardExpiryMonth
	,@cardExpiryYear
	,@cardType
	,@recurringPaymentCode
	,@cavvResponseCode
	,@amount
	,@errorMessage
	,@dateCreated

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_PaymentechResponse '
		CLOSE cur_PaymentechResponse
		DEALLOCATE CURSOR cur_PaymentechResponse
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..PaymentechResponse ' */

		INSERT arch_Accounting..PaymentechResponse
		(
			xactionId,
			responseCode,
			responseDate,
			approvalCode,
			avsResponseCode,
			securityResponseCode,
			cardNumber,
			cardExpiryMonth,
			cardExpiryYear,
			cardType,
			recurringPaymentCode,
			cavvResponseCode,
			amount,
			errorMessage,
			dateCreated,
			batchId)
		VALUES
		(
 			@xactionId,
 			@responseCode,
 			@responseDate,
 			@approvalCode,
 			@avsResponseCode,
 			@securityResponseCode,
 			@cardNumber,
 			@cardExpiryMonth,
 			@cardExpiryYear,
 			@cardType,
 			@recurringPaymentCode,
 			@cavvResponseCode,
 			@amount,
 			@errorMessage,
 			@dateCreated,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @returnMessage = 'Msg error: failed when insert PaymentechResponse where addressId= convert(varchar(20),@addressId)'
			PRINT @returnMessage
		END

	END
	FETCH cur_PaymentechResponse INTO
		@xactionId,
		@responseCode,
		@responseDate,
		@approvalCode,
		@avsResponseCode,
		@securityResponseCode,
		@cardNumber,
		@cardExpiryMonth,
		@cardExpiryYear,
		@cardType,
		@recurringPaymentCode,
		@cavvResponseCode,
		@amount,
		@errorMessage,
		@dateCreated,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingPaymentechResponse
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..PaymentechResponse
		SET
			xactionId = @xactionId,
			responseCode = @responseCode,
			responseDate = @responseDate,
			approvalCode = @approvalCode,
			avsResponseCode = @avsResponseCode,
			securityResponseCode = @securityResponseCode,
			cardNumber = @cardNumber,
			cardExpiryMonth = @cardExpiryMonth,
			cardExpiryYear = @cardExpiryYear,
			cardType = @cardType,
			recurringPaymentCode = @recurringPaymentCode,
			cavvResponseCode = @cavvResponseCode,
			amount = @amount,
			errorMessage = @errorMessage,
			dateCreated = @dateCreated,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO PaymentechResponse '

CLOSE cur_PaymentechResponse
DEALLOCATE CURSOR cur_PaymentechResponse

--exec p_sumPaymentechResponse @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcPaymentechResponse') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcPaymentechResponse >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcPaymentechResponse >>>'
go
