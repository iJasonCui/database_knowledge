IF OBJECT_ID('dbo.p_arcAccountTransaction') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcAccountTransaction
   IF OBJECT_ID('dbo.p_arcAccountTransaction') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcAccountTransaction >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcAccountTransaction >>>'
END
go
CREATE procedure dbo.p_arcAccountTransaction @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..AccountTransaction
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- AccountTransaction
DECLARE @xactionId   numeric(12,0)
DECLARE @userId   numeric(12,0)
DECLARE @xactionTypeId   tinyint
DECLARE @creditTypeId   smallint
DECLARE @contentId   smallint
DECLARE @product	char(1)
DECLARE @community	char(1)
DECLARE @credits   smallint
DECLARE @balance   smallint
DECLARE @userType	char(1)
DECLARE @description	varchar(255)
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

/* Declare cursor on AccountingLoad..AccountTransaction */
DECLARE cur_AccountTransaction CURSOR FOR
SELECT 
	@batchId
	,xactionId
	,userId
	,xactionTypeId
	,creditTypeId
	,contentId
	,product
	,community
	,credits
	,balance
	,userType
	,description
	,dateCreated
FROM AccountTransaction
FOR READ ONLY

OPEN cur_AccountTransaction
FETCH cur_AccountTransaction INTO
	@batchId
	,@xactionId
	,@userId
	,@xactionTypeId
	,@creditTypeId
	,@contentId
	,@product
	,@community
	,@credits
	,@balance
	,@userType
	,@description
	,@dateCreated

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_AccountTransaction '
		CLOSE cur_AccountTransaction
		DEALLOCATE CURSOR cur_AccountTransaction
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..AccountTransaction ' */

		INSERT arch_Accounting..AccountTransaction
		(
			xactionId,
			userId,
			xactionTypeId,
			creditTypeId,
			contentId,
			product,
			community,
			credits,
			balance,
			userType,
			description,
			dateCreated,
			batchId)
		VALUES
		(
 			@xactionId,
 			@userId,
 			@xactionTypeId,
 			@creditTypeId,
 			@contentId,
 			@product,
 			@community,
 			@credits,
 			@balance,
 			@userType,
 			@description,
 			@dateCreated,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert AccountTransaction where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_AccountTransaction INTO
		@xactionId,
		@userId,
		@xactionTypeId,
		@creditTypeId,
		@contentId,
		@product,
		@community,
		@credits,
		@balance,
		@userType,
		@description,
		@dateCreated,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingAccountTransaction
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..AccountTransaction
		SET
			xactionId = @xactionId,
			userId = @userId,
			xactionTypeId = @xactionTypeId,
			creditTypeId = @creditTypeId,
			contentId = @contentId,
			product = @product,
			community = @community,
			credits = @credits,
			balance = @balance,
			userType = @userType,
			description = @description,
			dateCreated = @dateCreated,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO AccountTransaction '

CLOSE cur_AccountTransaction
DEALLOCATE CURSOR cur_AccountTransaction

--exec p_sumAccountTransaction @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcAccountTransaction') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcAccountTransaction >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcAccountTransaction >>>'
go
