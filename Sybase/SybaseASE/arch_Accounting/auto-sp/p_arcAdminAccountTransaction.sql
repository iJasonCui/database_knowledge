IF OBJECT_ID('dbo.p_arcAdminAccountTransaction') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcAdminAccountTransaction
   IF OBJECT_ID('dbo.p_arcAdminAccountTransaction') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcAdminAccountTransaction >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcAdminAccountTransaction >>>'
END
go
CREATE procedure dbo.p_arcAdminAccountTransaction @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..AdminAccountTransaction
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- AdminAccountTransaction
DECLARE @xactionId   numeric(12,0)
DECLARE @adminUserId   int

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

/* Declare cursor on AccountingLoad..AdminAccountTransaction */
DECLARE cur_AdminAccountTransaction CURSOR FOR
SELECT 
	@batchId
	,xactionId
	,adminUserId
FROM AdminAccountTransaction
FOR READ ONLY

OPEN cur_AdminAccountTransaction
FETCH cur_AdminAccountTransaction INTO
	@batchId
	,@xactionId
	,@adminUserId

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_AdminAccountTransaction '
		CLOSE cur_AdminAccountTransaction
		DEALLOCATE CURSOR cur_AdminAccountTransaction
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..AdminAccountTransaction ' */

		INSERT arch_Accounting..AdminAccountTransaction
		(
			xactionId,
			adminUserId,
			batchId)
		VALUES
		(
 			@xactionId,
 			@adminUserId,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert AdminAccountTransaction where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_AdminAccountTransaction INTO
		@xactionId,
		@adminUserId,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingAdminAccountTransaction
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..AdminAccountTransaction
		SET
			xactionId = @xactionId,
			adminUserId = @adminUserId,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO AdminAccountTransaction '

CLOSE cur_AdminAccountTransaction
DEALLOCATE CURSOR cur_AdminAccountTransaction

--exec p_sumAdminAccountTransaction @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcAdminAccountTransaction') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcAdminAccountTransaction >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcAdminAccountTransaction >>>'
go
