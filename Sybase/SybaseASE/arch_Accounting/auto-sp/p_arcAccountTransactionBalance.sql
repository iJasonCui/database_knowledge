IF OBJECT_ID('dbo.p_arcAccountTransactionBalance') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcAccountTransactionBalance
   IF OBJECT_ID('dbo.p_arcAccountTransactionBalance') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcAccountTransactionBalance >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcAccountTransactionBalance >>>'
END
go
CREATE procedure dbo.p_arcAccountTransactionBalance @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..AccountTransactionBalance
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- AccountTransactionBalance
DECLARE @userId   numeric(12,0)

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

/* Declare cursor on AccountingLoad..AccountTransactionBalance */
DECLARE cur_AccountTransactionBalance CURSOR FOR
SELECT 
	@batchId
	,userId
FROM AccountTransactionBalance
FOR READ ONLY

OPEN cur_AccountTransactionBalance
FETCH cur_AccountTransactionBalance INTO
	@batchId
	,@userId

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_AccountTransactionBalance '
		CLOSE cur_AccountTransactionBalance
		DEALLOCATE CURSOR cur_AccountTransactionBalance
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..AccountTransactionBalance ' */

		INSERT arch_Accounting..AccountTransactionBalance
		(
			userId,
			batchId)
		VALUES
		(
 			@userId,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert AccountTransactionBalance where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_AccountTransactionBalance INTO
		@userId,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingAccountTransactionBalance
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..AccountTransactionBalance
		SET
			userId = @userId,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO AccountTransactionBalance '

CLOSE cur_AccountTransactionBalance
DEALLOCATE CURSOR cur_AccountTransactionBalance

--exec p_sumAccountTransactionBalance @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcAccountTransactionBalance') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcAccountTransactionBalance >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcAccountTransactionBalance >>>'
go
