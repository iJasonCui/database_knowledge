IF OBJECT_ID('dbo.p_arcUserSubscriptionAccount') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcUserSubscriptionAccount
   IF OBJECT_ID('dbo.p_arcUserSubscriptionAccount') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcUserSubscriptionAccount >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcUserSubscriptionAccount >>>'
END
go
CREATE procedure dbo.p_arcUserSubscriptionAccount @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..UserSubscriptionAccount
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- UserSubscriptionAccount
DECLARE @userId   numeric(12,0)
DECLARE @cardId   int
DECLARE @subscriptionOfferDetailId   smallint
DECLARE @subscriptionStatus	char(1)
DECLARE @autoRenew	char(1)
DECLARE @subscriptionEndDate   datetime
DECLARE @dateCreated   datetime
DECLARE @dateModified   datetime

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

/* Declare cursor on AccountingLoad..UserSubscriptionAccount */
DECLARE cur_UserSubscriptionAccount CURSOR FOR
SELECT 
	@batchId
	,userId
	,cardId
	,subscriptionOfferDetailId
	,subscriptionStatus
	,autoRenew
	,subscriptionEndDate
	,dateCreated
	,dateModified
FROM UserSubscriptionAccount
FOR READ ONLY

OPEN cur_UserSubscriptionAccount
FETCH cur_UserSubscriptionAccount INTO
	@batchId
	,@userId
	,@cardId
	,@subscriptionOfferDetailId
	,@subscriptionStatus
	,@autoRenew
	,@subscriptionEndDate
	,@dateCreated
	,@dateModified

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_UserSubscriptionAccount '
		CLOSE cur_UserSubscriptionAccount
		DEALLOCATE CURSOR cur_UserSubscriptionAccount
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..UserSubscriptionAccount ' */

		INSERT arch_Accounting..UserSubscriptionAccount
		(
			userId,
			cardId,
			subscriptionOfferDetailId,
			subscriptionStatus,
			autoRenew,
			subscriptionEndDate,
			dateCreated,
			dateModified,
			batchId)
		VALUES
		(
 			@userId,
 			@cardId,
 			@subscriptionOfferDetailId,
 			@subscriptionStatus,
 			@autoRenew,
 			@subscriptionEndDate,
 			@dateCreated,
 			@dateModified,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert UserSubscriptionAccount where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_UserSubscriptionAccount INTO
		@userId,
		@cardId,
		@subscriptionOfferDetailId,
		@subscriptionStatus,
		@autoRenew,
		@subscriptionEndDate,
		@dateCreated,
		@dateModified,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingUserSubscriptionAccount
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..UserSubscriptionAccount
		SET
			userId = @userId,
			cardId = @cardId,
			subscriptionOfferDetailId = @subscriptionOfferDetailId,
			subscriptionStatus = @subscriptionStatus,
			autoRenew = @autoRenew,
			subscriptionEndDate = @subscriptionEndDate,
			dateCreated = @dateCreated,
			dateModified = @dateModified,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO UserSubscriptionAccount '

CLOSE cur_UserSubscriptionAccount
DEALLOCATE CURSOR cur_UserSubscriptionAccount

--exec p_sumUserSubscriptionAccount @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcUserSubscriptionAccount') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcUserSubscriptionAccount >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcUserSubscriptionAccount >>>'
go
