IF OBJECT_ID('dbo.p_arcPurchaseDecline') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcPurchaseDecline
   IF OBJECT_ID('dbo.p_arcPurchaseDecline') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcPurchaseDecline >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcPurchaseDecline >>>'
END
go
CREATE procedure dbo.p_arcPurchaseDecline @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..PurchaseDecline
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- PurchaseDecline
DECLARE @xactionId   numeric(12,0)
DECLARE @paymentNumber	varchar(40)

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

/* Declare cursor on AccountingLoad..PurchaseDecline */
DECLARE cur_PurchaseDecline CURSOR FOR
SELECT 
	@batchId
	,xactionId
	,paymentNumber
FROM PurchaseDecline
FOR READ ONLY

OPEN cur_PurchaseDecline
FETCH cur_PurchaseDecline INTO
	@batchId
	,@xactionId
	,@paymentNumber

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_PurchaseDecline '
		CLOSE cur_PurchaseDecline
		DEALLOCATE CURSOR cur_PurchaseDecline
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..PurchaseDecline ' */

		INSERT arch_Accounting..PurchaseDecline
		(
			xactionId,
			paymentNumber,
			batchId)
		VALUES
		(
 			@xactionId,
 			@paymentNumber,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert PurchaseDecline where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_PurchaseDecline INTO
		@xactionId,
		@paymentNumber,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingPurchaseDecline
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..PurchaseDecline
		SET
			xactionId = @xactionId,
			paymentNumber = @paymentNumber,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO PurchaseDecline '

CLOSE cur_PurchaseDecline
DEALLOCATE CURSOR cur_PurchaseDecline

--exec p_sumPurchaseDecline @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcPurchaseDecline') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcPurchaseDecline >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcPurchaseDecline >>>'
go
