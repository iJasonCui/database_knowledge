IF OBJECT_ID('dbo.p_arcUserSubscriptionAccountHi') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcUserSubscriptionAccountHi
   IF OBJECT_ID('dbo.p_arcUserSubscriptionAccountHi') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcUserSubscriptionAccountHi >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcUserSubscriptionAccountHi >>>'
END
go
CREATE procedure dbo.p_arcUserSubscriptionAccountHi @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..UserSubscriptionAccountHistory
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- UserSubscriptionAccountHistory
DECLARE @userId   numeric(12,0)
DECLARE @cardId   int
DECLARE @subscriptionOfferDetailId   smallint
DECLARE @subscriptionStatus	char(1)
DECLARE @autoRenew	char(1)
DECLARE @subscriptionEndDate   datetime
DECLARE @cancelCodeId   tinyint
DECLARE @userCancelReason	varchar(255)
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

/* Declare cursor on AccountingLoad..UserSubscriptionAccountHistory */
DECLARE cur_Sub CURSOR FOR
SELECT 
	@batchId
	,userId
	,cardId
	,subscriptionOfferDetailId
	,subscriptionStatus
	,autoRenew
	,subscriptionEndDate
	,cancelCodeId
	,userCancelReason
	,dateCreated
	,dateModified
FROM UserSubscriptionAccountHistory
FOR READ ONLY

OPEN cur_Sub
FETCH cur_Sub INTO
	@batchId
	,@userId
	,@cardId
	,@subscriptionOfferDetailId
	,@subscriptionStatus
	,@autoRenew
	,@subscriptionEndDate
	,@cancelCodeId
	,@userCancelReason
	,@dateCreated
	,@dateModified

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_Sub '
		CLOSE cur_Sub
		DEALLOCATE CURSOR cur_Sub
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..UserSubscriptionAccountHistory ' */

		INSERT arch_Accounting..UserSubscriptionAccountHistory
		(
			userId,
			cardId,
			subscriptionOfferDetailId,
			subscriptionStatus,
			autoRenew,
			subscriptionEndDate,
			cancelCodeId,
			userCancelReason,
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
 			@cancelCodeId,
 			@userCancelReason,
 			@dateCreated,
 			@dateModified,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert UserSubscriptionAccountHistory where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_Sub INTO
		@userId,
		@cardId,
		@subscriptionOfferDetailId,
		@subscriptionStatus,
		@autoRenew,
		@subscriptionEndDate,
		@cancelCodeId,
		@userCancelReason,
		@dateCreated,
		@dateModified,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingUserSubscriptionAccountHistory
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..UserSubscriptionAccountHistory
		SET
			userId = @userId,
			cardId = @cardId,
			subscriptionOfferDetailId = @subscriptionOfferDetailId,
			subscriptionStatus = @subscriptionStatus,
			autoRenew = @autoRenew,
			subscriptionEndDate = @subscriptionEndDate,
			cancelCodeId = @cancelCodeId,
			userCancelReason = @userCancelReason,
			dateCreated = @dateCreated,
			dateModified = @dateModified,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO UserSubscriptionAccountHistory '

CLOSE cur_Sub
DEALLOCATE CURSOR cur_Sub

--exec p_sumUserSubscriptionAccountHistory @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcUserSubscriptionAccountHi') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcUserSubscriptionAccountHi >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcUserSubscriptionAccountHi >>>'
go
