IF OBJECT_ID('dbo.p_arcCompensationId') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcCompensationId
   IF OBJECT_ID('dbo.p_arcCompensationId') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcCompensationId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcCompensationId >>>'
END
go
CREATE procedure dbo.p_arcCompensationId @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..CompensationId
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- CompensationId
DECLARE @compensationId   int

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

/* Declare cursor on AccountingLoad..CompensationId */
DECLARE cur_CompensationId CURSOR FOR
SELECT 
	@batchId
	,compensationId
FROM CompensationId
FOR READ ONLY

OPEN cur_CompensationId
FETCH cur_CompensationId INTO
	@batchId
	,@compensationId

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_CompensationId '
		CLOSE cur_CompensationId
		DEALLOCATE CURSOR cur_CompensationId
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..CompensationId ' */

		INSERT arch_Accounting..CompensationId
		(
			compensationId,
			batchId)
		VALUES
		(
 			@compensationId,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert CompensationId where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_CompensationId INTO
		@compensationId,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingCompensationId
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..CompensationId
		SET
			compensationId = @compensationId,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO CompensationId '

CLOSE cur_CompensationId
DEALLOCATE CURSOR cur_CompensationId

--exec p_sumCompensationId @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcCompensationId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcCompensationId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcCompensationId >>>'
go
