IF OBJECT_ID('dbo.p_arcTaxRate') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcTaxRate
   IF OBJECT_ID('dbo.p_arcTaxRate') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcTaxRate >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcTaxRate >>>'
END
go
CREATE procedure dbo.p_arcTaxRate @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..TaxRate
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- TaxRate
DECLARE @billingLocationId   smallint
DECLARE @rate   numeric(4,3)
DECLARE @dateCreated   datetime
DECLARE @dateExpired   datetime

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

/* Declare cursor on AccountingLoad..TaxRate */
DECLARE cur_TaxRate CURSOR FOR
SELECT 
	@batchId
	,billingLocationId
	,rate
	,dateCreated
	,dateExpired
FROM TaxRate
FOR READ ONLY

OPEN cur_TaxRate
FETCH cur_TaxRate INTO
	@batchId
	,@billingLocationId
	,@rate
	,@dateCreated
	,@dateExpired

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_TaxRate '
		CLOSE cur_TaxRate
		DEALLOCATE CURSOR cur_TaxRate
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..TaxRate ' */

		INSERT arch_Accounting..TaxRate
		(
			billingLocationId,
			rate,
			dateCreated,
			dateExpired,
			batchId)
		VALUES
		(
 			@billingLocationId,
 			@rate,
 			@dateCreated,
 			@dateExpired,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert TaxRate where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_TaxRate INTO
		@billingLocationId,
		@rate,
		@dateCreated,
		@dateExpired,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingTaxRate
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..TaxRate
		SET
			billingLocationId = @billingLocationId,
			rate = @rate,
			dateCreated = @dateCreated,
			dateExpired = @dateExpired,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO TaxRate '

CLOSE cur_TaxRate
DEALLOCATE CURSOR cur_TaxRate

--exec p_sumTaxRate @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcTaxRate') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcTaxRate >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcTaxRate >>>'
go
