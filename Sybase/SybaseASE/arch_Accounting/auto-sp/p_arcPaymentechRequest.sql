IF OBJECT_ID('dbo.p_arcPaymentechRequest') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcPaymentechRequest
   IF OBJECT_ID('dbo.p_arcPaymentechRequest') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcPaymentechRequest >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcPaymentechRequest >>>'
END
go
CREATE procedure dbo.p_arcPaymentechRequest @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..PaymentechRequest
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- PaymentechRequest
DECLARE @userId   numeric(12,0)
DECLARE @xactionId   numeric(12,0)
DECLARE @merchantId	char(10)
DECLARE @actionCode	char(2)
DECLARE @cardType	char(2)
DECLARE @cardNumber	varchar(64)
DECLARE @cardExpiryMonth	char(2)
DECLARE @cardExpiryYear	char(2)
DECLARE @amount   numeric(10,0)
DECLARE @currencyCode	char(3)
DECLARE @cardHolderName	varchar(30)
DECLARE @userStreet	varchar(30)
DECLARE @userCity	varchar(20)
DECLARE @userState	char(2)
DECLARE @userCountryCode	char(2)
DECLARE @userPostalCode	varchar(10)
DECLARE @cardSecurityValue	varchar(4)
DECLARE @cardSecurityPresence	char(1)
DECLARE @cardIssueNumber	char(2)
DECLARE @cardStartMonth	char(2)
DECLARE @cardStartYear	char(2)
DECLARE @dateCreated   datetime

/* Declare Local Variable -- auditing purpose */
DECLARE @errorMessage 			varchar(255)
DECLARE @rowCountPassedCheck		int
DECLARE @rowCountArchived		int
DECLARE @rowCountReport			int
DECLARE @dateCreatedFrom		datetime
DECLARE @dateCreatedTo			datetime

/* Initialization */
SELECT @rowCountPassedCheck = 0
SELECT @rowCountArchived    = 0
SELECT @rowCountReport	    = 0

/* Declare cursor on AccountingLoad..PaymentechRequest */
DECLARE cur_PaymentechRequest CURSOR FOR
SELECT 
	@batchId
	,userId
	,xactionId
	,merchantId
	,actionCode
	,cardType
	,cardNumber
	,cardExpiryMonth
	,cardExpiryYear
	,amount
	,currencyCode
	,cardHolderName
	,userStreet
	,userCity
	,userState
	,userCountryCode
	,userPostalCode
	,cardSecurityValue
	,cardSecurityPresence
	,cardIssueNumber
	,cardStartMonth
	,cardStartYear
	,dateCreated
FROM PaymentechRequest
FOR READ ONLY

OPEN cur_PaymentechRequest
FETCH cur_PaymentechRequest INTO
	@batchId
	,@userId
	,@xactionId
	,@merchantId
	,@actionCode
	,@cardType
	,@cardNumber
	,@cardExpiryMonth
	,@cardExpiryYear
	,@amount
	,@currencyCode
	,@cardHolderName
	,@userStreet
	,@userCity
	,@userState
	,@userCountryCode
	,@userPostalCode
	,@cardSecurityValue
	,@cardSecurityPresence
	,@cardIssueNumber
	,@cardStartMonth
	,@cardStartYear
	,@dateCreated

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_PaymentechRequest '
		CLOSE cur_PaymentechRequest
		DEALLOCATE CURSOR cur_PaymentechRequest
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..PaymentechRequest ' */

		INSERT arch_Accounting..PaymentechRequest
		(
			userId,
			xactionId,
			merchantId,
			actionCode,
			cardType,
			cardNumber,
			cardExpiryMonth,
			cardExpiryYear,
			amount,
			currencyCode,
			cardHolderName,
			userStreet,
			userCity,
			userState,
			userCountryCode,
			userPostalCode,
			cardSecurityValue,
			cardSecurityPresence,
			cardIssueNumber,
			cardStartMonth,
			cardStartYear,
			dateCreated,
			batchId)
		VALUES
		(
 			@userId,
 			@xactionId,
 			@merchantId,
 			@actionCode,
 			@cardType,
 			@cardNumber,
 			@cardExpiryMonth,
 			@cardExpiryYear,
 			@amount,
 			@currencyCode,
 			@cardHolderName,
 			@userStreet,
 			@userCity,
 			@userState,
 			@userCountryCode,
 			@userPostalCode,
 			@cardSecurityValue,
 			@cardSecurityPresence,
 			@cardIssueNumber,
 			@cardStartMonth,
 			@cardStartYear,
 			@dateCreated,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert PaymentechRequest where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_PaymentechRequest INTO
		@userId,
		@xactionId,
		@merchantId,
		@actionCode,
		@cardType,
		@cardNumber,
		@cardExpiryMonth,
		@cardExpiryYear,
		@amount,
		@currencyCode,
		@cardHolderName,
		@userStreet,
		@userCity,
		@userState,
		@userCountryCode,
		@userPostalCode,
		@cardSecurityValue,
		@cardSecurityPresence,
		@cardIssueNumber,
		@cardStartMonth,
		@cardStartYear,
		@dateCreated,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingPaymentechRequest
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..PaymentechRequest
		SET
			userId = @userId,
			xactionId = @xactionId,
			merchantId = @merchantId,
			actionCode = @actionCode,
			cardType = @cardType,
			cardNumber = @cardNumber,
			cardExpiryMonth = @cardExpiryMonth,
			cardExpiryYear = @cardExpiryYear,
			amount = @amount,
			currencyCode = @currencyCode,
			cardHolderName = @cardHolderName,
			userStreet = @userStreet,
			userCity = @userCity,
			userState = @userState,
			userCountryCode = @userCountryCode,
			userPostalCode = @userPostalCode,
			cardSecurityValue = @cardSecurityValue,
			cardSecurityPresence = @cardSecurityPresence,
			cardIssueNumber = @cardIssueNumber,
			cardStartMonth = @cardStartMonth,
			cardStartYear = @cardStartYear,
			dateCreated = @dateCreated,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO PaymentechRequest '

CLOSE cur_PaymentechRequest
DEALLOCATE CURSOR cur_PaymentechRequest

--exec p_sumPaymentechRequest @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcPaymentechRequest') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcPaymentechRequest >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcPaymentechRequest >>>'
go
