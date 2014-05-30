IF OBJECT_ID('dbo.p_arcCurrencyHistory') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcCurrencyHistory
   IF OBJECT_ID('dbo.p_arcCurrencyHistory') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcCurrencyHistory >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcCurrencyHistory >>>'
END
go
CREATE procedure dbo.p_arcCurrencyHistory @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..CurrencyHistory
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- CurrencyHistory
DECLARE @currencyId   tinyint
DECLARE @convertUSD   numeric(12,5)
DECLARE @adminUserId   int
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

/* Declare cursor on AccountingLoad..CurrencyHistory */
DECLARE cur_CurrencyHistory CURSOR FOR
SELECT 
	@batchId
	,currencyId
	,convertUSD
	,adminUserId
	,dateCreated
FROM CurrencyHistory
FOR READ ONLY

OPEN cur_CurrencyHistory
FETCH cur_CurrencyHistory INTO
	@batchId
	,@currencyId
	,@convertUSD
	,@adminUserId
	,@dateCreated

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_CurrencyHistory '
		CLOSE cur_CurrencyHistory
		DEALLOCATE CURSOR cur_CurrencyHistory
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..CurrencyHistory ' */

		INSERT arch_Accounting..CurrencyHistory
		(
			currencyId,
			convertUSD,
			adminUserId,
			dateCreated,
			batchId)
		VALUES
		(
 			@currencyId,
 			@convertUSD,
 			@adminUserId,
 			@dateCreated,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert CurrencyHistory where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_CurrencyHistory INTO
		@currencyId,
		@convertUSD,
		@adminUserId,
		@dateCreated,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingCurrencyHistory
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..CurrencyHistory
		SET
			currencyId = @currencyId,
			convertUSD = @convertUSD,
			adminUserId = @adminUserId,
			dateCreated = @dateCreated,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO CurrencyHistory '

CLOSE cur_CurrencyHistory
DEALLOCATE CURSOR cur_CurrencyHistory

--exec p_sumCurrencyHistory @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcCurrencyHistory') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcCurrencyHistory >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcCurrencyHistory >>>'
go
