IF OBJECT_ID('dbo.p_arcAccountFlag') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcAccountFlag
   IF OBJECT_ID('dbo.p_arcAccountFlag') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcAccountFlag >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcAccountFlag >>>'
END
go
CREATE procedure dbo.p_arcAccountFlag @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..AccountFlag
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- AccountFlag
DECLARE @userId   numeric(12,0)
DECLARE @reasonContentId   smallint
DECLARE @reviewed	char(1)
DECLARE @adminUserId   int
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

/* Declare cursor on AccountingLoad..AccountFlag */
DECLARE cur_AccountFlag CURSOR FOR
SELECT 
	@batchId
	,userId
	,reasonContentId
	,reviewed
	,adminUserId
	,dateCreated
	,dateModified
FROM AccountFlag
FOR READ ONLY

OPEN cur_AccountFlag
FETCH cur_AccountFlag INTO
	@batchId
	,@userId
	,@reasonContentId
	,@reviewed
	,@adminUserId
	,@dateCreated
	,@dateModified

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_AccountFlag '
		CLOSE cur_AccountFlag
		DEALLOCATE CURSOR cur_AccountFlag
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..AccountFlag ' */

		INSERT arch_Accounting..AccountFlag
		(
			userId,
			reasonContentId,
			reviewed,
			adminUserId,
			dateCreated,
			dateModified,
			batchId)
		VALUES
		(
 			@userId,
 			@reasonContentId,
 			@reviewed,
 			@adminUserId,
 			@dateCreated,
 			@dateModified,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert AccountFlag where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_AccountFlag INTO
		@userId,
		@reasonContentId,
		@reviewed,
		@adminUserId,
		@dateCreated,
		@dateModified,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingAccountFlag
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..AccountFlag
		SET
			userId = @userId,
			reasonContentId = @reasonContentId,
			reviewed = @reviewed,
			adminUserId = @adminUserId,
			dateCreated = @dateCreated,
			dateModified = @dateModified,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO AccountFlag '

CLOSE cur_AccountFlag
DEALLOCATE CURSOR cur_AccountFlag

--exec p_sumAccountFlag @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcAccountFlag') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcAccountFlag >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcAccountFlag >>>'
go
