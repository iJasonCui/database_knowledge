IF OBJECT_ID('dbo.p_arcXactionType') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcXactionType
   IF OBJECT_ID('dbo.p_arcXactionType') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcXactionType >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcXactionType >>>'
END
go
CREATE procedure dbo.p_arcXactionType @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..XactionType
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- XactionType
DECLARE @xactionTypeId   tinyint
DECLARE @description	varchar(32)

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

/* Declare cursor on AccountingLoad..XactionType */
DECLARE cur_XactionType CURSOR FOR
SELECT 
	@batchId
	,xactionTypeId
	,description
FROM XactionType
FOR READ ONLY

OPEN cur_XactionType
FETCH cur_XactionType INTO
	@batchId
	,@xactionTypeId
	,@description

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_XactionType '
		CLOSE cur_XactionType
		DEALLOCATE CURSOR cur_XactionType
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..XactionType ' */

		INSERT arch_Accounting..XactionType
		(
			xactionTypeId,
			description,
			batchId)
		VALUES
		(
 			@xactionTypeId,
 			@description,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert XactionType where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_XactionType INTO
		@xactionTypeId,
		@description,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingXactionType
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..XactionType
		SET
			xactionTypeId = @xactionTypeId,
			description = @description,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO XactionType '

CLOSE cur_XactionType
DEALLOCATE CURSOR cur_XactionType

--exec p_sumXactionType @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcXactionType') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcXactionType >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcXactionType >>>'
go
