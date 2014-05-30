IF OBJECT_ID('dbo.p_arcPurchaseOffer') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcPurchaseOffer
   IF OBJECT_ID('dbo.p_arcPurchaseOffer') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcPurchaseOffer >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcPurchaseOffer >>>'
END
go
CREATE procedure dbo.p_arcPurchaseOffer @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..PurchaseOffer
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- PurchaseOffer
DECLARE @purchaseOfferId   smallint
DECLARE @currencyId   tinyint
DECLARE @accountType	char(1)
DECLARE @description	varchar(32)
DECLARE @dateCreated   datetime
DECLARE @dateExpiry	char(18)

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

/* Declare cursor on AccountingLoad..PurchaseOffer */
DECLARE cur_PurchaseOffer CURSOR FOR
SELECT 
	@batchId
	,purchaseOfferId
	,currencyId
	,accountType
	,description
	,dateCreated
	,dateExpiry
FROM PurchaseOffer
FOR READ ONLY

OPEN cur_PurchaseOffer
FETCH cur_PurchaseOffer INTO
	@batchId
	,@purchaseOfferId
	,@currencyId
	,@accountType
	,@description
	,@dateCreated
	,@dateExpiry

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_PurchaseOffer '
		CLOSE cur_PurchaseOffer
		DEALLOCATE CURSOR cur_PurchaseOffer
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..PurchaseOffer ' */

		INSERT arch_Accounting..PurchaseOffer
		(
			purchaseOfferId,
			currencyId,
			accountType,
			description,
			dateCreated,
			dateExpiry,
			batchId)
		VALUES
		(
 			@purchaseOfferId,
 			@currencyId,
 			@accountType,
 			@description,
 			@dateCreated,
 			@dateExpiry,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert PurchaseOffer where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_PurchaseOffer INTO
		@purchaseOfferId,
		@currencyId,
		@accountType,
		@description,
		@dateCreated,
		@dateExpiry,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingPurchaseOffer
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..PurchaseOffer
		SET
			purchaseOfferId = @purchaseOfferId,
			currencyId = @currencyId,
			accountType = @accountType,
			description = @description,
			dateCreated = @dateCreated,
			dateExpiry = @dateExpiry,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO PurchaseOffer '

CLOSE cur_PurchaseOffer
DEALLOCATE CURSOR cur_PurchaseOffer

--exec p_sumPurchaseOffer @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcPurchaseOffer') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcPurchaseOffer >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcPurchaseOffer >>>'
go
