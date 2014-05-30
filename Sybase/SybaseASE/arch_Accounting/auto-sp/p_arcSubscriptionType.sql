IF OBJECT_ID('dbo.p_arcSubscriptionType') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcSubscriptionType
   IF OBJECT_ID('dbo.p_arcSubscriptionType') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcSubscriptionType >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcSubscriptionType >>>'
END
go
CREATE procedure dbo.p_arcSubscriptionType @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..SubscriptionType
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- SubscriptionType
DECLARE @subscriptionTypeId   smallint
DECLARE @contentId   smallint
DECLARE @description	varchar(64)

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

/* Declare cursor on AccountingLoad..SubscriptionType */
DECLARE cur_SubscriptionType CURSOR FOR
SELECT 
	@batchId
	,subscriptionTypeId
	,contentId
	,description
FROM SubscriptionType
FOR READ ONLY

OPEN cur_SubscriptionType
FETCH cur_SubscriptionType INTO
	@batchId
	,@subscriptionTypeId
	,@contentId
	,@description

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_SubscriptionType '
		CLOSE cur_SubscriptionType
		DEALLOCATE CURSOR cur_SubscriptionType
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..SubscriptionType ' */

		INSERT arch_Accounting..SubscriptionType
		(
			subscriptionTypeId,
			contentId,
			description,
			batchId)
		VALUES
		(
 			@subscriptionTypeId,
 			@contentId,
 			@description,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert SubscriptionType where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_SubscriptionType INTO
		@subscriptionTypeId,
		@contentId,
		@description,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingSubscriptionType
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..SubscriptionType
		SET
			subscriptionTypeId = @subscriptionTypeId,
			contentId = @contentId,
			description = @description,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO SubscriptionType '

CLOSE cur_SubscriptionType
DEALLOCATE CURSOR cur_SubscriptionType

--exec p_sumSubscriptionType @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcSubscriptionType') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcSubscriptionType >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcSubscriptionType >>>'
go
