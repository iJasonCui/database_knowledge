IF OBJECT_ID('dbo.p_arcPurchaseType') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcPurchaseType
   IF OBJECT_ID('dbo.p_arcPurchaseType') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcPurchaseType >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcPurchaseType >>>'
END
go
CREATE procedure dbo.p_arcPurchaseType @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..PurchaseType
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- PurchaseType
DECLARE @purchaseTypeId   tinyint
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

/* Declare cursor on AccountingLoad..PurchaseType */
DECLARE cur_PurchaseType CURSOR FOR
SELECT 
	@batchId
	,purchaseTypeId
	,description
FROM PurchaseType
FOR READ ONLY

OPEN cur_PurchaseType
FETCH cur_PurchaseType INTO
	@batchId
	,@purchaseTypeId
	,@description

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_PurchaseType '
		CLOSE cur_PurchaseType
		DEALLOCATE CURSOR cur_PurchaseType
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..PurchaseType ' */

		INSERT arch_Accounting..PurchaseType
		(
			purchaseTypeId,
			description,
			batchId)
		VALUES
		(
 			@purchaseTypeId,
 			@description,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert PurchaseType where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_PurchaseType INTO
		@purchaseTypeId,
		@description,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingPurchaseType
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..PurchaseType
		SET
			purchaseTypeId = @purchaseTypeId,
			description = @description,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO PurchaseType '

CLOSE cur_PurchaseType
DEALLOCATE CURSOR cur_PurchaseType

--exec p_sumPurchaseType @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcPurchaseType') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcPurchaseType >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcPurchaseType >>>'
go
