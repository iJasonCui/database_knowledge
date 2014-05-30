IF OBJECT_ID('dbo.p_arcSubscriptionTransaction') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcSubscriptionTransaction
   IF OBJECT_ID('dbo.p_arcSubscriptionTransaction') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcSubscriptionTransaction >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcSubscriptionTransaction >>>'
END
go
CREATE procedure dbo.p_arcSubscriptionTransaction @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..SubscriptionTransaction
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- SubscriptionTransaction
DECLARE @xactionId   numeric(12,0)
DECLARE @cardId   int
DECLARE @userId   numeric(12,0)
DECLARE @xactionTypeId   tinyint
DECLARE @contentId   smallint
DECLARE @subscriptionTypeId   smallint
DECLARE @duration   smallint
DECLARE @userTrans   bit
DECLARE @description	varchar(255)
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

/* Declare cursor on AccountingLoad..SubscriptionTransaction */
DECLARE cur_SubscriptionTransaction CURSOR FOR
SELECT 
	@batchId
	,xactionId
	,cardId
	,userId
	,xactionTypeId
	,contentId
	,subscriptionTypeId
	,duration
	,userTrans
	,description
	,dateCreated
FROM SubscriptionTransaction
FOR READ ONLY

OPEN cur_SubscriptionTransaction
FETCH cur_SubscriptionTransaction INTO
	@batchId
	,@xactionId
	,@cardId
	,@userId
	,@xactionTypeId
	,@contentId
	,@subscriptionTypeId
	,@duration
	,@userTrans
	,@description
	,@dateCreated

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_SubscriptionTransaction '
		CLOSE cur_SubscriptionTransaction
		DEALLOCATE CURSOR cur_SubscriptionTransaction
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..SubscriptionTransaction ' */

		INSERT arch_Accounting..SubscriptionTransaction
		(
			xactionId,
			cardId,
			userId,
			xactionTypeId,
			contentId,
			subscriptionTypeId,
			duration,
			userTrans,
			description,
			dateCreated,
			batchId)
		VALUES
		(
 			@xactionId,
 			@cardId,
 			@userId,
 			@xactionTypeId,
 			@contentId,
 			@subscriptionTypeId,
 			@duration,
 			@userTrans,
 			@description,
 			@dateCreated,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert SubscriptionTransaction where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_SubscriptionTransaction INTO
		@xactionId,
		@cardId,
		@userId,
		@xactionTypeId,
		@contentId,
		@subscriptionTypeId,
		@duration,
		@userTrans,
		@description,
		@dateCreated,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingSubscriptionTransaction
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..SubscriptionTransaction
		SET
			xactionId = @xactionId,
			cardId = @cardId,
			userId = @userId,
			xactionTypeId = @xactionTypeId,
			contentId = @contentId,
			subscriptionTypeId = @subscriptionTypeId,
			duration = @duration,
			userTrans = @userTrans,
			description = @description,
			dateCreated = @dateCreated,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO SubscriptionTransaction '

CLOSE cur_SubscriptionTransaction
DEALLOCATE CURSOR cur_SubscriptionTransaction

--exec p_sumSubscriptionTransaction @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcSubscriptionTransaction') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcSubscriptionTransaction >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcSubscriptionTransaction >>>'
go
