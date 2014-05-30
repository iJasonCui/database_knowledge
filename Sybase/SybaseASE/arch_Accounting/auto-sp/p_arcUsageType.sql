IF OBJECT_ID('dbo.p_arcUsageType') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcUsageType
   IF OBJECT_ID('dbo.p_arcUsageType') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcUsageType >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcUsageType >>>'
END
go
CREATE procedure dbo.p_arcUsageType @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..UsageType
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- UsageType
DECLARE @usageTypeId   tinyint
DECLARE @contentId   smallint
DECLARE @xactionTypeId   tinyint
DECLARE @hasDuration	char(1)
DECLARE @description	varchar(32)
DECLARE @appletDesc	varchar(16)

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

/* Declare cursor on AccountingLoad..UsageType */
DECLARE cur_UsageType CURSOR FOR
SELECT 
	@batchId
	,usageTypeId
	,contentId
	,xactionTypeId
	,hasDuration
	,description
	,appletDesc
FROM UsageType
FOR READ ONLY

OPEN cur_UsageType
FETCH cur_UsageType INTO
	@batchId
	,@usageTypeId
	,@contentId
	,@xactionTypeId
	,@hasDuration
	,@description
	,@appletDesc

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_UsageType '
		CLOSE cur_UsageType
		DEALLOCATE CURSOR cur_UsageType
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..UsageType ' */

		INSERT arch_Accounting..UsageType
		(
			usageTypeId,
			contentId,
			xactionTypeId,
			hasDuration,
			description,
			appletDesc,
			batchId)
		VALUES
		(
 			@usageTypeId,
 			@contentId,
 			@xactionTypeId,
 			@hasDuration,
 			@description,
 			@appletDesc,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert UsageType where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_UsageType INTO
		@usageTypeId,
		@contentId,
		@xactionTypeId,
		@hasDuration,
		@description,
		@appletDesc,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingUsageType
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..UsageType
		SET
			usageTypeId = @usageTypeId,
			contentId = @contentId,
			xactionTypeId = @xactionTypeId,
			hasDuration = @hasDuration,
			description = @description,
			appletDesc = @appletDesc,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO UsageType '

CLOSE cur_UsageType
DEALLOCATE CURSOR cur_UsageType

--exec p_sumUsageType @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcUsageType') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcUsageType >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcUsageType >>>'
go
