IF OBJECT_ID('dbo.p_arcBatchIdLog') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcBatchIdLog
   IF OBJECT_ID('dbo.p_arcBatchIdLog') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcBatchIdLog >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcBatchIdLog >>>'
END
go
CREATE procedure dbo.p_arcBatchIdLog @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..BatchIdLog
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- BatchIdLog
DECLARE @BatchId   int
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

/* Declare cursor on AccountingLoad..BatchIdLog */
DECLARE cur_BatchIdLog CURSOR FOR
SELECT 
	@batchId
	,BatchId
	,dateCreated
FROM BatchIdLog
FOR READ ONLY

OPEN cur_BatchIdLog
FETCH cur_BatchIdLog INTO
	@batchId
	,@BatchId
	,@dateCreated

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_BatchIdLog '
		CLOSE cur_BatchIdLog
		DEALLOCATE CURSOR cur_BatchIdLog
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..BatchIdLog ' */

		INSERT arch_Accounting..BatchIdLog
		(
			BatchId,
			dateCreated,
			batchId)
		VALUES
		(
 			@BatchId,
 			@dateCreated,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert BatchIdLog where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_BatchIdLog INTO
		@BatchId,
		@dateCreated,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingBatchIdLog
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..BatchIdLog
		SET
			BatchId = @BatchId,
			dateCreated = @dateCreated,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO BatchIdLog '

CLOSE cur_BatchIdLog
DEALLOCATE CURSOR cur_BatchIdLog

--exec p_sumBatchIdLog @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcBatchIdLog') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcBatchIdLog >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcBatchIdLog >>>'
go
