IF OBJECT_ID('dbo.p_arcDefaultUserAccount') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcDefaultUserAccount
   IF OBJECT_ID('dbo.p_arcDefaultUserAccount') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcDefaultUserAccount >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcDefaultUserAccount >>>'
END
go
CREATE procedure dbo.p_arcDefaultUserAccount @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..DefaultUserAccount
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- DefaultUserAccount
DECLARE @billingLocationId   smallint
DECLARE @defaultPurchaseOfferId   smallint
DECLARE @defaultAccountType	char(1)
DECLARE @defaultUsageCellId   smallint

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

/* Declare cursor on AccountingLoad..DefaultUserAccount */
DECLARE cur_DefaultUserAccount CURSOR FOR
SELECT 
	@batchId
	,billingLocationId
	,defaultPurchaseOfferId
	,defaultAccountType
	,defaultUsageCellId
FROM DefaultUserAccount
FOR READ ONLY

OPEN cur_DefaultUserAccount
FETCH cur_DefaultUserAccount INTO
	@batchId
	,@billingLocationId
	,@defaultPurchaseOfferId
	,@defaultAccountType
	,@defaultUsageCellId

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_DefaultUserAccount '
		CLOSE cur_DefaultUserAccount
		DEALLOCATE CURSOR cur_DefaultUserAccount
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..DefaultUserAccount ' */

		INSERT arch_Accounting..DefaultUserAccount
		(
			billingLocationId,
			defaultPurchaseOfferId,
			defaultAccountType,
			defaultUsageCellId,
			batchId)
		VALUES
		(
 			@billingLocationId,
 			@defaultPurchaseOfferId,
 			@defaultAccountType,
 			@defaultUsageCellId,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert DefaultUserAccount where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_DefaultUserAccount INTO
		@billingLocationId,
		@defaultPurchaseOfferId,
		@defaultAccountType,
		@defaultUsageCellId,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingDefaultUserAccount
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..DefaultUserAccount
		SET
			billingLocationId = @billingLocationId,
			defaultPurchaseOfferId = @defaultPurchaseOfferId,
			defaultAccountType = @defaultAccountType,
			defaultUsageCellId = @defaultUsageCellId,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO DefaultUserAccount '

CLOSE cur_DefaultUserAccount
DEALLOCATE CURSOR cur_DefaultUserAccount

--exec p_sumDefaultUserAccount @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcDefaultUserAccount') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcDefaultUserAccount >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcDefaultUserAccount >>>'
go
