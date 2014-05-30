IF OBJECT_ID('dbo.p_arcCurrency') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcCurrency
   IF OBJECT_ID('dbo.p_arcCurrency') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcCurrency >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcCurrency >>>'
END
go
CREATE procedure dbo.p_arcCurrency @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..Currency
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- Currency
DECLARE @currencyId   tinyint
DECLARE @currencyCode	char(3)
DECLARE @currencyDesc	varchar(32)
DECLARE @convertUSD   numeric(12,5)
DECLARE @precisionDigits   tinyint
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

/* Declare cursor on AccountingLoad..Currency */
DECLARE cur_Currency CURSOR FOR
SELECT 
	@batchId
	,currencyId
	,currencyCode
	,currencyDesc
	,convertUSD
	,precisionDigits
	,dateCreated
	,dateModified
FROM Currency
FOR READ ONLY

OPEN cur_Currency
FETCH cur_Currency INTO
	@batchId
	,@currencyId
	,@currencyCode
	,@currencyDesc
	,@convertUSD
	,@precisionDigits
	,@dateCreated
	,@dateModified

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_Currency '
		CLOSE cur_Currency
		DEALLOCATE CURSOR cur_Currency
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..Currency ' */

		INSERT arch_Accounting..Currency
		(
			currencyId,
			currencyCode,
			currencyDesc,
			convertUSD,
			precisionDigits,
			dateCreated,
			dateModified,
			batchId)
		VALUES
		(
 			@currencyId,
 			@currencyCode,
 			@currencyDesc,
 			@convertUSD,
 			@precisionDigits,
 			@dateCreated,
 			@dateModified,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert Currency where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_Currency INTO
		@currencyId,
		@currencyCode,
		@currencyDesc,
		@convertUSD,
		@precisionDigits,
		@dateCreated,
		@dateModified,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingCurrency
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..Currency
		SET
			currencyId = @currencyId,
			currencyCode = @currencyCode,
			currencyDesc = @currencyDesc,
			convertUSD = @convertUSD,
			precisionDigits = @precisionDigits,
			dateCreated = @dateCreated,
			dateModified = @dateModified,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO Currency '

CLOSE cur_Currency
DEALLOCATE CURSOR cur_Currency

--exec p_sumCurrency @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcCurrency') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcCurrency >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcCurrency >>>'
go
