IF OBJECT_ID('dbo.p_arcBillingLocation') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcBillingLocation
   IF OBJECT_ID('dbo.p_arcBillingLocation') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcBillingLocation >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcBillingLocation >>>'
END
go
CREATE procedure dbo.p_arcBillingLocation @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..BillingLocation
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- BillingLocation
DECLARE @billingLocationId   smallint
DECLARE @billingLocationCode	char(3)
DECLARE @billingLocationDesc	varchar(32)
DECLARE @currencyId   tinyint
DECLARE @merchantId   tinyint
DECLARE @displayTax	char(1)

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

/* Declare cursor on AccountingLoad..BillingLocation */
DECLARE cur_BillingLocation CURSOR FOR
SELECT 
	@batchId
	,billingLocationId
	,billingLocationCode
	,billingLocationDesc
	,currencyId
	,merchantId
	,displayTax
FROM BillingLocation
FOR READ ONLY

OPEN cur_BillingLocation
FETCH cur_BillingLocation INTO
	@batchId
	,@billingLocationId
	,@billingLocationCode
	,@billingLocationDesc
	,@currencyId
	,@merchantId
	,@displayTax

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_BillingLocation '
		CLOSE cur_BillingLocation
		DEALLOCATE CURSOR cur_BillingLocation
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..BillingLocation ' */

		INSERT arch_Accounting..BillingLocation
		(
			billingLocationId,
			billingLocationCode,
			billingLocationDesc,
			currencyId,
			merchantId,
			displayTax,
			batchId)
		VALUES
		(
 			@billingLocationId,
 			@billingLocationCode,
 			@billingLocationDesc,
 			@currencyId,
 			@merchantId,
 			@displayTax,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert BillingLocation where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_BillingLocation INTO
		@billingLocationId,
		@billingLocationCode,
		@billingLocationDesc,
		@currencyId,
		@merchantId,
		@displayTax,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingBillingLocation
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..BillingLocation
		SET
			billingLocationId = @billingLocationId,
			billingLocationCode = @billingLocationCode,
			billingLocationDesc = @billingLocationDesc,
			currencyId = @currencyId,
			merchantId = @merchantId,
			displayTax = @displayTax,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO BillingLocation '

CLOSE cur_BillingLocation
DEALLOCATE CURSOR cur_BillingLocation

--exec p_sumBillingLocation @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcBillingLocation') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcBillingLocation >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcBillingLocation >>>'
go
