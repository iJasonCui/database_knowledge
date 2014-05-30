IF OBJECT_ID('dbo.p_arcUsageCellDetail') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcUsageCellDetail
   IF OBJECT_ID('dbo.p_arcUsageCellDetail') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcUsageCellDetail >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcUsageCellDetail >>>'
END
go
CREATE procedure dbo.p_arcUsageCellDetail @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..UsageCellDetail
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- UsageCellDetail
DECLARE @usageCellId   smallint
DECLARE @usageTypeId   tinyint
DECLARE @credits   smallint
DECLARE @duration   smallint

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

/* Declare cursor on AccountingLoad..UsageCellDetail */
DECLARE cur_UsageCellDetail CURSOR FOR
SELECT 
	@batchId
	,usageCellId
	,usageTypeId
	,credits
	,duration
FROM UsageCellDetail
FOR READ ONLY

OPEN cur_UsageCellDetail
FETCH cur_UsageCellDetail INTO
	@batchId
	,@usageCellId
	,@usageTypeId
	,@credits
	,@duration

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_UsageCellDetail '
		CLOSE cur_UsageCellDetail
		DEALLOCATE CURSOR cur_UsageCellDetail
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..UsageCellDetail ' */

		INSERT arch_Accounting..UsageCellDetail
		(
			usageCellId,
			usageTypeId,
			credits,
			duration,
			batchId)
		VALUES
		(
 			@usageCellId,
 			@usageTypeId,
 			@credits,
 			@duration,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert UsageCellDetail where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_UsageCellDetail INTO
		@usageCellId,
		@usageTypeId,
		@credits,
		@duration,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingUsageCellDetail
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..UsageCellDetail
		SET
			usageCellId = @usageCellId,
			usageTypeId = @usageTypeId,
			credits = @credits,
			duration = @duration,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO UsageCellDetail '

CLOSE cur_UsageCellDetail
DEALLOCATE CURSOR cur_UsageCellDetail

--exec p_sumUsageCellDetail @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcUsageCellDetail') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcUsageCellDetail >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcUsageCellDetail >>>'
go
