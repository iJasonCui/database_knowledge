IF OBJECT_ID('dbo.p_arcBadCreditCard') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcBadCreditCard
   IF OBJECT_ID('dbo.p_arcBadCreditCard') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcBadCreditCard >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcBadCreditCard >>>'
END
go
CREATE procedure dbo.p_arcBadCreditCard @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..BadCreditCard
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- BadCreditCard
DECLARE @creditCardId   int
DECLARE @reasonContentId   smallint
DECLARE @reason	varchar(255)
DECLARE @status	char(1)
DECLARE @dateCreated   datetime
DECLARE @dateModified   datetime

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

/* Declare cursor on AccountingLoad..BadCreditCard */
DECLARE cur_BadCreditCard CURSOR FOR
SELECT 
	@batchId
	,creditCardId
	,reasonContentId
	,reason
	,status
	,dateCreated
	,dateModified
FROM BadCreditCard
FOR READ ONLY

OPEN cur_BadCreditCard
FETCH cur_BadCreditCard INTO
	@batchId
	,@creditCardId
	,@reasonContentId
	,@reason
	,@status
	,@dateCreated
	,@dateModified

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_BadCreditCard '
		CLOSE cur_BadCreditCard
		DEALLOCATE CURSOR cur_BadCreditCard
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..BadCreditCard ' */

		INSERT arch_Accounting..BadCreditCard
		(
			creditCardId,
			reasonContentId,
			reason,
			status,
			dateCreated,
			dateModified,
			batchId)
		VALUES
		(
 			@creditCardId,
 			@reasonContentId,
 			@reason,
 			@status,
 			@dateCreated,
 			@dateModified,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert BadCreditCard where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_BadCreditCard INTO
		@creditCardId,
		@reasonContentId,
		@reason,
		@status,
		@dateCreated,
		@dateModified,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingBadCreditCard
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..BadCreditCard
		SET
			creditCardId = @creditCardId,
			reasonContentId = @reasonContentId,
			reason = @reason,
			status = @status,
			dateCreated = @dateCreated,
			dateModified = @dateModified,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO BadCreditCard '

CLOSE cur_BadCreditCard
DEALLOCATE CURSOR cur_BadCreditCard

--exec p_sumBadCreditCard @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcBadCreditCard') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcBadCreditCard >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcBadCreditCard >>>'
go
