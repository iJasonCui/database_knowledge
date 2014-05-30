IF OBJECT_ID('dbo.p_arcNonFinancialXActionId') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcNonFinancialXActionId
   IF OBJECT_ID('dbo.p_arcNonFinancialXActionId') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcNonFinancialXActionId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcNonFinancialXActionId >>>'
END
go
CREATE procedure dbo.p_arcNonFinancialXActionId @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..NonFinancialXActionId
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- NonFinancialXActionId
DECLARE @nonFinancialXActionId   int

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

/* Declare cursor on AccountingLoad..NonFinancialXActionId */
DECLARE cur_NonFinancialXActionId CURSOR FOR
SELECT 
	@batchId
	,nonFinancialXActionId
FROM NonFinancialXActionId
FOR READ ONLY

OPEN cur_NonFinancialXActionId
FETCH cur_NonFinancialXActionId INTO
	@batchId
	,@nonFinancialXActionId

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_NonFinancialXActionId '
		CLOSE cur_NonFinancialXActionId
		DEALLOCATE CURSOR cur_NonFinancialXActionId
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..NonFinancialXActionId ' */

		INSERT arch_Accounting..NonFinancialXActionId
		(
			nonFinancialXActionId,
			batchId)
		VALUES
		(
 			@nonFinancialXActionId,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert NonFinancialXActionId where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_NonFinancialXActionId INTO
		@nonFinancialXActionId,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingNonFinancialXActionId
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..NonFinancialXActionId
		SET
			nonFinancialXActionId = @nonFinancialXActionId,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO NonFinancialXActionId '

CLOSE cur_NonFinancialXActionId
DEALLOCATE CURSOR cur_NonFinancialXActionId

--exec p_sumNonFinancialXActionId @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcNonFinancialXActionId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcNonFinancialXActionId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcNonFinancialXActionId >>>'
go
