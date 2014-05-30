IF OBJECT_ID('dbo.p_arcUsageCell') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcUsageCell
   IF OBJECT_ID('dbo.p_arcUsageCell') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcUsageCell >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcUsageCell >>>'
END
go
CREATE procedure dbo.p_arcUsageCell @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..UsageCell
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- UsageCell
DECLARE @usageCellId   smallint
DECLARE @description	varchar(32)
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

/* Declare cursor on AccountingLoad..UsageCell */
DECLARE cur_UsageCell CURSOR FOR
SELECT 
	@batchId
	,usageCellId
	,description
	,dateCreated
FROM UsageCell
FOR READ ONLY

OPEN cur_UsageCell
FETCH cur_UsageCell INTO
	@batchId
	,@usageCellId
	,@description
	,@dateCreated

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_UsageCell '
		CLOSE cur_UsageCell
		DEALLOCATE CURSOR cur_UsageCell
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..UsageCell ' */

		INSERT arch_Accounting..UsageCell
		(
			usageCellId,
			description,
			dateCreated,
			batchId)
		VALUES
		(
 			@usageCellId,
 			@description,
 			@dateCreated,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert UsageCell where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_UsageCell INTO
		@usageCellId,
		@description,
		@dateCreated,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingUsageCell
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..UsageCell
		SET
			usageCellId = @usageCellId,
			description = @description,
			dateCreated = @dateCreated,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO UsageCell '

CLOSE cur_UsageCell
DEALLOCATE CURSOR cur_UsageCell

--exec p_sumUsageCell @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcUsageCell') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcUsageCell >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcUsageCell >>>'
go
