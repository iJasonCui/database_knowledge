IF OBJECT_ID('dbo.p_arcAccountingEvent') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcAccountingEvent
   IF OBJECT_ID('dbo.p_arcAccountingEvent') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcAccountingEvent >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcAccountingEvent >>>'
END
go
CREATE procedure dbo.p_arcAccountingEvent @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..AccountingEvent
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- AccountingEvent
DECLARE @userId   numeric(12,0)
DECLARE @eventType	char(1)
DECLARE @xactionId   numeric(12,0)
DECLARE @cardNum	varchar(64)
DECLARE @encodedCardNum	varchar(64)
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

/* Declare cursor on AccountingLoad..AccountingEvent */
DECLARE cur_AccountingEvent CURSOR FOR
SELECT 
	@batchId
	,userId
	,eventType
	,xactionId
	,cardNum
	,encodedCardNum
	,dateCreated
FROM AccountingEvent
FOR READ ONLY

OPEN cur_AccountingEvent
FETCH cur_AccountingEvent INTO
	@batchId
	,@userId
	,@eventType
	,@xactionId
	,@cardNum
	,@encodedCardNum
	,@dateCreated

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_AccountingEvent '
		CLOSE cur_AccountingEvent
		DEALLOCATE CURSOR cur_AccountingEvent
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..AccountingEvent ' */

		INSERT arch_Accounting..AccountingEvent
		(
			userId,
			eventType,
			xactionId,
			cardNum,
			encodedCardNum,
			dateCreated,
			batchId)
		VALUES
		(
 			@userId,
 			@eventType,
 			@xactionId,
 			@cardNum,
 			@encodedCardNum,
 			@dateCreated,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert AccountingEvent where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_AccountingEvent INTO
		@userId,
		@eventType,
		@xactionId,
		@cardNum,
		@encodedCardNum,
		@dateCreated,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingAccountingEvent
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..AccountingEvent
		SET
			userId = @userId,
			eventType = @eventType,
			xactionId = @xactionId,
			cardNum = @cardNum,
			encodedCardNum = @encodedCardNum,
			dateCreated = @dateCreated,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO AccountingEvent '

CLOSE cur_AccountingEvent
DEALLOCATE CURSOR cur_AccountingEvent

--exec p_sumAccountingEvent @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcAccountingEvent') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcAccountingEvent >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcAccountingEvent >>>'
go
