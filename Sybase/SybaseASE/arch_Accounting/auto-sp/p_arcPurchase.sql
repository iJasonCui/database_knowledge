IF OBJECT_ID('dbo.p_arcPurchase') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcPurchase
   IF OBJECT_ID('dbo.p_arcPurchase') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcPurchase >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcPurchase >>>'
END
go
CREATE procedure dbo.p_arcPurchase @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..Purchase
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- Purchase
DECLARE @xactionId   numeric(12,0)
DECLARE @userId   numeric(12,0)
DECLARE @purchaseTypeId   tinyint
DECLARE @purchaseOfferDetailId   smallint
DECLARE @billingLocationId   smallint
DECLARE @currencyId   tinyint
DECLARE @xactionTypeId   tinyint
DECLARE @creditCardId   int
DECLARE @refXactionId   numeric(12,0)
DECLARE @cost   numeric(10,2)
DECLARE @costUSD   numeric(5,2)
DECLARE @tax   numeric(10,2)
DECLARE @taxUSD   numeric(5,2)
DECLARE @cardProcessor	char(1)
DECLARE @paymentNumber	varchar(40)
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

/* Declare cursor on AccountingLoad..Purchase */
DECLARE cur_Purchase CURSOR FOR
SELECT 
	@batchId
	,xactionId
	,userId
	,purchaseTypeId
	,purchaseOfferDetailId
	,billingLocationId
	,currencyId
	,xactionTypeId
	,creditCardId
	,refXactionId
	,cost
	,costUSD
	,tax
	,taxUSD
	,cardProcessor
	,paymentNumber
	,dateCreated
FROM Purchase
FOR READ ONLY

OPEN cur_Purchase
FETCH cur_Purchase INTO
	@batchId
	,@xactionId
	,@userId
	,@purchaseTypeId
	,@purchaseOfferDetailId
	,@billingLocationId
	,@currencyId
	,@xactionTypeId
	,@creditCardId
	,@refXactionId
	,@cost
	,@costUSD
	,@tax
	,@taxUSD
	,@cardProcessor
	,@paymentNumber
	,@dateCreated

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_Purchase '
		CLOSE cur_Purchase
		DEALLOCATE CURSOR cur_Purchase
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..Purchase ' */

		INSERT arch_Accounting..Purchase
		(
			xactionId,
			userId,
			purchaseTypeId,
			purchaseOfferDetailId,
			billingLocationId,
			currencyId,
			xactionTypeId,
			creditCardId,
			refXactionId,
			cost,
			costUSD,
			tax,
			taxUSD,
			cardProcessor,
			paymentNumber,
			dateCreated,
			batchId)
		VALUES
		(
 			@xactionId,
 			@userId,
 			@purchaseTypeId,
 			@purchaseOfferDetailId,
 			@billingLocationId,
 			@currencyId,
 			@xactionTypeId,
 			@creditCardId,
 			@refXactionId,
 			@cost,
 			@costUSD,
 			@tax,
 			@taxUSD,
 			@cardProcessor,
 			@paymentNumber,
 			@dateCreated,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert Purchase where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_Purchase INTO
		@xactionId,
		@userId,
		@purchaseTypeId,
		@purchaseOfferDetailId,
		@billingLocationId,
		@currencyId,
		@xactionTypeId,
		@creditCardId,
		@refXactionId,
		@cost,
		@costUSD,
		@tax,
		@taxUSD,
		@cardProcessor,
		@paymentNumber,
		@dateCreated,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingPurchase
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..Purchase
		SET
			xactionId = @xactionId,
			userId = @userId,
			purchaseTypeId = @purchaseTypeId,
			purchaseOfferDetailId = @purchaseOfferDetailId,
			billingLocationId = @billingLocationId,
			currencyId = @currencyId,
			xactionTypeId = @xactionTypeId,
			creditCardId = @creditCardId,
			refXactionId = @refXactionId,
			cost = @cost,
			costUSD = @costUSD,
			tax = @tax,
			taxUSD = @taxUSD,
			cardProcessor = @cardProcessor,
			paymentNumber = @paymentNumber,
			dateCreated = @dateCreated,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO Purchase '

CLOSE cur_Purchase
DEALLOCATE CURSOR cur_Purchase

--exec p_sumPurchase @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcPurchase') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcPurchase >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcPurchase >>>'
go
