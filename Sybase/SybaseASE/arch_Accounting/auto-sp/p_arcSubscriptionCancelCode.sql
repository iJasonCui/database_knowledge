IF OBJECT_ID('dbo.p_arcSubscriptionCancelCode') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcSubscriptionCancelCode
   IF OBJECT_ID('dbo.p_arcSubscriptionCancelCode') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcSubscriptionCancelCode >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcSubscriptionCancelCode >>>'
END
go
CREATE procedure dbo.p_arcSubscriptionCancelCode @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..SubscriptionCancelCode
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- SubscriptionCancelCode
DECLARE @cancelCodeId   tinyint
DECLARE @contentId   smallint
DECLARE @customerChoice	char(1)
DECLARE @ordinal   tinyint
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

/* Declare cursor on AccountingLoad..SubscriptionCancelCode */
DECLARE cur_SubscriptionCancelCode CURSOR FOR
SELECT 
	@batchId
	,cancelCodeId
	,contentId
	,customerChoice
	,ordinal
	,description
FROM SubscriptionCancelCode
FOR READ ONLY

OPEN cur_SubscriptionCancelCode
FETCH cur_SubscriptionCancelCode INTO
	@batchId
	,@cancelCodeId
	,@contentId
	,@customerChoice
	,@ordinal
	,@description

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_SubscriptionCancelCode '
		CLOSE cur_SubscriptionCancelCode
		DEALLOCATE CURSOR cur_SubscriptionCancelCode
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..SubscriptionCancelCode ' */

		INSERT arch_Accounting..SubscriptionCancelCode
		(
			cancelCodeId,
			contentId,
			customerChoice,
			ordinal,
			description,
			batchId)
		VALUES
		(
 			@cancelCodeId,
 			@contentId,
 			@customerChoice,
 			@ordinal,
 			@description,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert SubscriptionCancelCode where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_SubscriptionCancelCode INTO
		@cancelCodeId,
		@contentId,
		@customerChoice,
		@ordinal,
		@description,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingSubscriptionCancelCode
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..SubscriptionCancelCode
		SET
			cancelCodeId = @cancelCodeId,
			contentId = @contentId,
			customerChoice = @customerChoice,
			ordinal = @ordinal,
			description = @description,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO SubscriptionCancelCode '

CLOSE cur_SubscriptionCancelCode
DEALLOCATE CURSOR cur_SubscriptionCancelCode

--exec p_sumSubscriptionCancelCode @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcSubscriptionCancelCode') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcSubscriptionCancelCode >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcSubscriptionCancelCode >>>'
go
