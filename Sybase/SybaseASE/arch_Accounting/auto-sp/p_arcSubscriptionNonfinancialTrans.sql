IF OBJECT_ID('dbo.p_arcSubNonfinancialTrans') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcSubNonfinancialTrans
   IF OBJECT_ID('dbo.p_arcSubNonfinancialTrans') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcSubNonfinancialTrans >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcSubNonfinancialTrans >>>'
END
go
CREATE procedure dbo.p_arcSubNonfinancialTrans @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..SubscriptionNonfinancialTrans
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- SubscriptionNonfinancialTrans
DECLARE @nonFinancialXActionId   int
DECLARE @cardId   int
DECLARE @userId   numeric(12,0)
DECLARE @contentId   smallint
DECLARE @subscriptionTypeId   smallint
DECLARE @duration   smallint
DECLARE @description	varchar(255)
DECLARE @dateCreated   datetime
--DECLARE @batchId   int

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

/* Declare cursor on AccountingLoad..SubscriptionNonfinancialTrans */
DECLARE cur_SubNonfinancialTrans CURSOR FOR
SELECT 
	@batchId
	,nonFinancialXActionId
	,cardId
	,userId
	,contentId
	,subscriptionTypeId
	,duration
	,description
	,dateCreated
--	,batchId
FROM SubscriptionNonfinancialTrans
FOR READ ONLY

OPEN cur_SubNonfinancialTrans
FETCH cur_SubNonfinancialTrans INTO
	@batchId
	,@nonFinancialXActionId
	,@cardId
	,@userId
	,@contentId
	,@subscriptionTypeId
	,@duration
	,@description
	,@dateCreated
--	,@batchId

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_SubNonfinancialTrans '
		CLOSE cur_SubNonfinancialTrans
		DEALLOCATE CURSOR cur_SubNonfinancialTrans
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..SubscriptionNonfinancialTrans ' */

		INSERT arch_Accounting..SubscriptionNonfinancialTrans
		(
			nonFinancialXActionId,
			cardId,
			userId,
			contentId,
			subscriptionTypeId,
			duration,
			description,
			dateCreated,
			batchId)
		VALUES
		(
 			@nonFinancialXActionId,
 			@cardId,
 			@userId,
 			@contentId,
 			@subscriptionTypeId,
 			@duration,
 			@description,
 			@dateCreated,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert SubscriptionNonfinancialTrans where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_SubNonfinancialTrans INTO
        @batchId,
		@nonFinancialXActionId,
		@cardId,
		@userId,
		@contentId,
		@subscriptionTypeId,
		@duration,
		@description,
		@dateCreated

END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingSubscriptionNonfinancialTrans
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..SubscriptionNonfinancialTrans
		SET
			nonFinancialXActionId = @nonFinancialXActionId,
			cardId = @cardId,
			userId = @userId,
			contentId = @contentId,
			subscriptionTypeId = @subscriptionTypeId,
			duration = @duration,
			description = @description,
			dateCreated = @dateCreated,
			batchId = @batchId,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO SubscriptionNonfinancialTrans '

CLOSE cur_SubNonfinancialTrans
DEALLOCATE CURSOR cur_SubNonfinancialTrans

--exec p_sumSubscriptionNonfinancialTrans @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcSubNonfinancialTrans') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcSubNonfinancialTrans >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcSubNonfinancialTrans >>>'
go
