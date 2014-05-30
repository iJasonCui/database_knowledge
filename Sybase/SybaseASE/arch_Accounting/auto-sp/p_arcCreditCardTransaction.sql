IF OBJECT_ID('dbo.p_arcCreditCardTransaction') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcCreditCardTransaction
   IF OBJECT_ID('dbo.p_arcCreditCardTransaction') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcCreditCardTransaction >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcCreditCardTransaction >>>'
END
go
CREATE procedure dbo.p_arcCreditCardTransaction @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..CreditCardTransaction
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- CreditCardTransaction
DECLARE @xactionId   numeric(12,0)
DECLARE @dateCreated   datetime
DECLARE @CCTranStatusId   int
DECLARE @BatchId   int
DECLARE @dateVoided   datetime
DECLARE @dateExtracted   datetime
DECLARE @dateSettled   datetime
DECLARE @responseCode   smallint

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

/* Declare cursor on AccountingLoad..CreditCardTransaction */
DECLARE cur_CreditCardTransaction CURSOR FOR
SELECT 
	@batchId
	,xactionId
	,dateCreated
	,CCTranStatusId
	,batchId
	,dateVoided
	,dateExtracted
	,dateSettled
	,responseCode
FROM CreditCardTransaction
FOR READ ONLY

OPEN cur_CreditCardTransaction
FETCH cur_CreditCardTransaction INTO
	@batchId
	,@xactionId
	,@dateCreated
	,@CCTranStatusId
	,@BatchId
	,@dateVoided
	,@dateExtracted
	,@dateSettled
	,@responseCode

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_CreditCardTransaction '
		CLOSE cur_CreditCardTransaction
		DEALLOCATE CURSOR cur_CreditCardTransaction
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..CreditCardTransaction ' */

		INSERT arch_Accounting..CreditCardTransaction
		(
			xactionId,
			dateCreated,
			CCTranStatusId,
			BatchId,
			dateVoided,
			dateExtracted,
			dateSettled,
			responseCode,
			batchId)
		VALUES
		(
 			@xactionId,
 			@dateCreated,
 			@CCTranStatusId,
 			@BatchId,
 			@dateVoided,
 			@dateExtracted,
 			@dateSettled,
 			@responseCode,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert CreditCardTransaction where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_CreditCardTransaction INTO
		@xactionId,
		@dateCreated,
		@CCTranStatusId,
		@BatchId,
		@dateVoided,
		@dateExtracted,
		@dateSettled,
		@responseCode,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingCreditCardTransaction
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..CreditCardTransaction
		SET
			xactionId = @xactionId,
			dateCreated = @dateCreated,
			CCTranStatusId = @CCTranStatusId,
			BatchId = @BatchId,
			dateVoided = @dateVoided,
			dateExtracted = @dateExtracted,
			dateSettled = @dateSettled,
			responseCode = @responseCode,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO CreditCardTransaction '

CLOSE cur_CreditCardTransaction
DEALLOCATE CURSOR cur_CreditCardTransaction

--exec p_sumCreditCardTransaction @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcCreditCardTransaction') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcCreditCardTransaction >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcCreditCardTransaction >>>'
go
