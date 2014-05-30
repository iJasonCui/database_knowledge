IF OBJECT_ID('dbo.p_arcSettlementResponse') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcSettlementResponse
   IF OBJECT_ID('dbo.p_arcSettlementResponse') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcSettlementResponse >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcSettlementResponse >>>'
END
go
CREATE procedure dbo.p_arcSettlementResponse @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..SettlementResponse
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- SettlementResponse
DECLARE @xactionId   numeric(12,0)
DECLARE @responseCode   int
DECLARE @responseDate	char(6)
DECLARE @cardNumber	varchar(64)
DECLARE @partialCardNumber	char(4)
DECLARE @cardType	char(2)
DECLARE @amount   numeric(10,0)
DECLARE @merchantId	char(10)
DECLARE @currencyCode	char(3)
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

/* Declare cursor on AccountingLoad..SettlementResponse */
DECLARE cur_SettlementResponse CURSOR FOR
SELECT 
	@batchId
	,xactionId
	,responseCode
	,responseDate
	,cardNumber
	,partialCardNumber
	,cardType
	,amount
	,merchantId
	,currencyCode
	,dateCreated
FROM SettlementResponse
FOR READ ONLY

OPEN cur_SettlementResponse
FETCH cur_SettlementResponse INTO
	@batchId
	,@xactionId
	,@responseCode
	,@responseDate
	,@cardNumber
	,@partialCardNumber
	,@cardType
	,@amount
	,@merchantId
	,@currencyCode
	,@dateCreated

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_SettlementResponse '
		CLOSE cur_SettlementResponse
		DEALLOCATE CURSOR cur_SettlementResponse
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..SettlementResponse ' */

		INSERT arch_Accounting..SettlementResponse
		(
			xactionId,
			responseCode,
			responseDate,
			cardNumber,
			partialCardNumber,
			cardType,
			amount,
			merchantId,
			currencyCode,
			dateCreated,
			batchId)
		VALUES
		(
 			@xactionId,
 			@responseCode,
 			@responseDate,
 			@cardNumber,
 			@partialCardNumber,
 			@cardType,
 			@amount,
 			@merchantId,
 			@currencyCode,
 			@dateCreated,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert SettlementResponse where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_SettlementResponse INTO
		@xactionId,
		@responseCode,
		@responseDate,
		@cardNumber,
		@partialCardNumber,
		@cardType,
		@amount,
		@merchantId,
		@currencyCode,
		@dateCreated,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingSettlementResponse
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..SettlementResponse
		SET
			xactionId = @xactionId,
			responseCode = @responseCode,
			responseDate = @responseDate,
			cardNumber = @cardNumber,
			partialCardNumber = @partialCardNumber,
			cardType = @cardType,
			amount = @amount,
			merchantId = @merchantId,
			currencyCode = @currencyCode,
			dateCreated = @dateCreated,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO SettlementResponse '

CLOSE cur_SettlementResponse
DEALLOCATE CURSOR cur_SettlementResponse

--exec p_sumSettlementResponse @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcSettlementResponse') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcSettlementResponse >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcSettlementResponse >>>'
go
