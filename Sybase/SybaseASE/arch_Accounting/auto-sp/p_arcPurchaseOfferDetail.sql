IF OBJECT_ID('dbo.p_arcPurchaseOfferDetail') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcPurchaseOfferDetail
   IF OBJECT_ID('dbo.p_arcPurchaseOfferDetail') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcPurchaseOfferDetail >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcPurchaseOfferDetail >>>'
END
go
CREATE procedure dbo.p_arcPurchaseOfferDetail @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..PurchaseOfferDetail
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- PurchaseOfferDetail
DECLARE @purchaseOfferDetailId   smallint
DECLARE @purchaseOfferId   smallint
DECLARE @contentId   smallint
DECLARE @restrictedPurchaseTypeId   tinyint
DECLARE @ordinal   tinyint
DECLARE @cost   numeric(10,3)
DECLARE @credits   smallint
DECLARE @duration   smallint
DECLARE @bonusCredits   smallint
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

/* Declare cursor on AccountingLoad..PurchaseOfferDetail */
DECLARE cur_PurchaseOfferDetail CURSOR FOR
SELECT 
	@batchId
	,purchaseOfferDetailId
	,purchaseOfferId
	,contentId
	,restrictedPurchaseTypeId
	,ordinal
	,cost
	,credits
	,duration
	,bonusCredits
	,dateCreated
FROM PurchaseOfferDetail
FOR READ ONLY

OPEN cur_PurchaseOfferDetail
FETCH cur_PurchaseOfferDetail INTO
	@batchId
	,@purchaseOfferDetailId
	,@purchaseOfferId
	,@contentId
	,@restrictedPurchaseTypeId
	,@ordinal
	,@cost
	,@credits
	,@duration
	,@bonusCredits
	,@dateCreated

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_PurchaseOfferDetail '
		CLOSE cur_PurchaseOfferDetail
		DEALLOCATE CURSOR cur_PurchaseOfferDetail
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..PurchaseOfferDetail ' */

		INSERT arch_Accounting..PurchaseOfferDetail
		(
			purchaseOfferDetailId,
			purchaseOfferId,
			contentId,
			restrictedPurchaseTypeId,
			ordinal,
			cost,
			credits,
			duration,
			bonusCredits,
			dateCreated,
			batchId)
		VALUES
		(
 			@purchaseOfferDetailId,
 			@purchaseOfferId,
 			@contentId,
 			@restrictedPurchaseTypeId,
 			@ordinal,
 			@cost,
 			@credits,
 			@duration,
 			@bonusCredits,
 			@dateCreated,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert PurchaseOfferDetail where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_PurchaseOfferDetail INTO
		@purchaseOfferDetailId,
		@purchaseOfferId,
		@contentId,
		@restrictedPurchaseTypeId,
		@ordinal,
		@cost,
		@credits,
		@duration,
		@bonusCredits,
		@dateCreated,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingPurchaseOfferDetail
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..PurchaseOfferDetail
		SET
			purchaseOfferDetailId = @purchaseOfferDetailId,
			purchaseOfferId = @purchaseOfferId,
			contentId = @contentId,
			restrictedPurchaseTypeId = @restrictedPurchaseTypeId,
			ordinal = @ordinal,
			cost = @cost,
			credits = @credits,
			duration = @duration,
			bonusCredits = @bonusCredits,
			dateCreated = @dateCreated,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO PurchaseOfferDetail '

CLOSE cur_PurchaseOfferDetail
DEALLOCATE CURSOR cur_PurchaseOfferDetail

--exec p_sumPurchaseOfferDetail @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcPurchaseOfferDetail') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcPurchaseOfferDetail >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcPurchaseOfferDetail >>>'
go
