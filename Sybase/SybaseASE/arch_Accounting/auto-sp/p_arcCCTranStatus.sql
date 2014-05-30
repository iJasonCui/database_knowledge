IF OBJECT_ID('dbo.p_arcCCTranStatus') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcCCTranStatus
   IF OBJECT_ID('dbo.p_arcCCTranStatus') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcCCTranStatus >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcCCTranStatus >>>'
END
go
CREATE procedure dbo.p_arcCCTranStatus @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..CCTranStatus
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- CCTranStatus
DECLARE @CCTranStatusId   int
DECLARE @dateCreated   datetime
DECLARE @dateModified   datetime
DECLARE @CCTranStatusCode	varchar(10)
DECLARE @CCTranStatusName	varchar(40)

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

/* Declare cursor on AccountingLoad..CCTranStatus */
DECLARE cur_CCTranStatus CURSOR FOR
SELECT 
	@batchId
	,CCTranStatusId
	,dateCreated
	,dateModified
	,CCTranStatusCode
	,CCTranStatusName
FROM CCTranStatus
FOR READ ONLY

OPEN cur_CCTranStatus
FETCH cur_CCTranStatus INTO
	@batchId
	,@CCTranStatusId
	,@dateCreated
	,@dateModified
	,@CCTranStatusCode
	,@CCTranStatusName

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_CCTranStatus '
		CLOSE cur_CCTranStatus
		DEALLOCATE CURSOR cur_CCTranStatus
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..CCTranStatus ' */

		INSERT arch_Accounting..CCTranStatus
		(
			CCTranStatusId,
			dateCreated,
			dateModified,
			CCTranStatusCode,
			CCTranStatusName,
			batchId)
		VALUES
		(
 			@CCTranStatusId,
 			@dateCreated,
 			@dateModified,
 			@CCTranStatusCode,
 			@CCTranStatusName,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert CCTranStatus where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_CCTranStatus INTO
		@CCTranStatusId,
		@dateCreated,
		@dateModified,
		@CCTranStatusCode,
		@CCTranStatusName,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingCCTranStatus
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..CCTranStatus
		SET
			CCTranStatusId = @CCTranStatusId,
			dateCreated = @dateCreated,
			dateModified = @dateModified,
			CCTranStatusCode = @CCTranStatusCode,
			CCTranStatusName = @CCTranStatusName,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO CCTranStatus '

CLOSE cur_CCTranStatus
DEALLOCATE CURSOR cur_CCTranStatus

--exec p_sumCCTranStatus @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcCCTranStatus') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcCCTranStatus >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcCCTranStatus >>>'
go
