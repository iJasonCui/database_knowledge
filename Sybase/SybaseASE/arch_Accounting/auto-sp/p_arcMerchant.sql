IF OBJECT_ID('dbo.p_arcMerchant') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcMerchant
   IF OBJECT_ID('dbo.p_arcMerchant') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcMerchant >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcMerchant >>>'
END
go
CREATE procedure dbo.p_arcMerchant @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..Merchant
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- Merchant
DECLARE @merchantId   tinyint
DECLARE @merchantCode	varchar(32)
DECLARE @description	varchar(255)

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

/* Declare cursor on AccountingLoad..Merchant */
DECLARE cur_Merchant CURSOR FOR
SELECT 
	@batchId
	,merchantId
	,merchantCode
	,description
FROM Merchant
FOR READ ONLY

OPEN cur_Merchant
FETCH cur_Merchant INTO
	@batchId
	,@merchantId
	,@merchantCode
	,@description

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_Merchant '
		CLOSE cur_Merchant
		DEALLOCATE CURSOR cur_Merchant
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..Merchant ' */

		INSERT arch_Accounting..Merchant
		(
			merchantId,
			merchantCode,
			description,
			batchId)
		VALUES
		(
 			@merchantId,
 			@merchantCode,
 			@description,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert Merchant where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_Merchant INTO
		@merchantId,
		@merchantCode,
		@description,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingMerchant
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..Merchant
		SET
			merchantId = @merchantId,
			merchantCode = @merchantCode,
			description = @description,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO Merchant '

CLOSE cur_Merchant
DEALLOCATE CURSOR cur_Merchant

--exec p_sumMerchant @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcMerchant') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcMerchant >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcMerchant >>>'
go
