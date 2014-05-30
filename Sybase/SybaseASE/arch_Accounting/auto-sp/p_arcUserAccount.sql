IF OBJECT_ID('dbo.p_arcUserAccount') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcUserAccount
   IF OBJECT_ID('dbo.p_arcUserAccount') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcUserAccount >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcUserAccount >>>'
END
go
CREATE procedure dbo.p_arcUserAccount @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..UserAccount
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- UserAccount
DECLARE @userId   numeric(12,0)
DECLARE @billingLocationId   smallint
DECLARE @purchaseOfferId   smallint
DECLARE @usageCellId   smallint
DECLARE @accountType	char(1)
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

/* Declare cursor on AccountingLoad..UserAccount */
DECLARE cur_UserAccount CURSOR FOR
SELECT 
	@batchId
	,userId
	,billingLocationId
	,purchaseOfferId
	,usageCellId
	,accountType
	,dateCreated
	,dateModified
FROM UserAccount
FOR READ ONLY

OPEN cur_UserAccount
FETCH cur_UserAccount INTO
	@batchId
	,@userId
	,@billingLocationId
	,@purchaseOfferId
	,@usageCellId
	,@accountType
	,@dateCreated
	,@dateModified

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_UserAccount '
		CLOSE cur_UserAccount
		DEALLOCATE CURSOR cur_UserAccount
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..UserAccount ' */

		INSERT arch_Accounting..UserAccount
		(
			userId,
			billingLocationId,
			purchaseOfferId,
			usageCellId,
			accountType,
			dateCreated,
			dateModified,
			batchId)
		VALUES
		(
 			@userId,
 			@billingLocationId,
 			@purchaseOfferId,
 			@usageCellId,
 			@accountType,
 			@dateCreated,
 			@dateModified,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert UserAccount where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_UserAccount INTO
		@userId,
		@billingLocationId,
		@purchaseOfferId,
		@usageCellId,
		@accountType,
		@dateCreated,
		@dateModified,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingUserAccount
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..UserAccount
		SET
			userId = @userId,
			billingLocationId = @billingLocationId,
			purchaseOfferId = @purchaseOfferId,
			usageCellId = @usageCellId,
			accountType = @accountType,
			dateCreated = @dateCreated,
			dateModified = @dateModified,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO UserAccount '

CLOSE cur_UserAccount
DEALLOCATE CURSOR cur_UserAccount

--exec p_sumUserAccount @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcUserAccount') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcUserAccount >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcUserAccount >>>'
go
