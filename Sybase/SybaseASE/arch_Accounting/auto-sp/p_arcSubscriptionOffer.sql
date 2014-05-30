IF OBJECT_ID('dbo.p_arcSubscriptionOffer') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcSubscriptionOffer
   IF OBJECT_ID('dbo.p_arcSubscriptionOffer') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcSubscriptionOffer >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcSubscriptionOffer >>>'
END
go
CREATE procedure dbo.p_arcSubscriptionOffer @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..SubscriptionOffer
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- SubscriptionOffer
DECLARE @subscriptionOfferId   smallint
DECLARE @currencyId   tinyint
DECLARE @description	varchar(32)
DECLARE @dateCreated   datetime
DECLARE @dateExpiry   datetime

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

/* Declare cursor on AccountingLoad..SubscriptionOffer */
DECLARE cur_SubscriptionOffer CURSOR FOR
SELECT 
	@batchId
	,subscriptionOfferId
	,currencyId
	,description
	,dateCreated
	,dateExpiry
FROM SubscriptionOffer
FOR READ ONLY

OPEN cur_SubscriptionOffer
FETCH cur_SubscriptionOffer INTO
	@batchId
	,@subscriptionOfferId
	,@currencyId
	,@description
	,@dateCreated
	,@dateExpiry

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_SubscriptionOffer '
		CLOSE cur_SubscriptionOffer
		DEALLOCATE CURSOR cur_SubscriptionOffer
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..SubscriptionOffer ' */

		INSERT arch_Accounting..SubscriptionOffer
		(
			subscriptionOfferId,
			currencyId,
			description,
			dateCreated,
			dateExpiry,
			batchId)
		VALUES
		(
 			@subscriptionOfferId,
 			@currencyId,
 			@description,
 			@dateCreated,
 			@dateExpiry,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert SubscriptionOffer where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_SubscriptionOffer INTO
		@subscriptionOfferId,
		@currencyId,
		@description,
		@dateCreated,
		@dateExpiry,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingSubscriptionOffer
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..SubscriptionOffer
		SET
			subscriptionOfferId = @subscriptionOfferId,
			currencyId = @currencyId,
			description = @description,
			dateCreated = @dateCreated,
			dateExpiry = @dateExpiry,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO SubscriptionOffer '

CLOSE cur_SubscriptionOffer
DEALLOCATE CURSOR cur_SubscriptionOffer

--exec p_sumSubscriptionOffer @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcSubscriptionOffer') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcSubscriptionOffer >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcSubscriptionOffer >>>'
go
