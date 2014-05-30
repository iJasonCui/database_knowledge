IF OBJECT_ID('dbo.p_arcCreditBalance') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcCreditBalance
   IF OBJECT_ID('dbo.p_arcCreditBalance') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcCreditBalance >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcCreditBalance >>>'
END
go
CREATE procedure dbo.p_arcCreditBalance @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..CreditBalance
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- CreditBalance
DECLARE @userId   numeric(12,0)
DECLARE @creditTypeId   smallint
DECLARE @credits   smallint
DECLARE @dateExpiry   datetime
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

/* Declare cursor on AccountingLoad..CreditBalance */
DECLARE cur_CreditBalance CURSOR FOR
SELECT 
	@batchId
	,userId
	,creditTypeId
	,credits
	,dateExpiry
	,dateCreated
	,dateModified
FROM CreditBalance
FOR READ ONLY

OPEN cur_CreditBalance
FETCH cur_CreditBalance INTO
	@batchId
	,@userId
	,@creditTypeId
	,@credits
	,@dateExpiry
	,@dateCreated
	,@dateModified

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_CreditBalance '
		CLOSE cur_CreditBalance
		DEALLOCATE CURSOR cur_CreditBalance
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..CreditBalance ' */

		INSERT arch_Accounting..CreditBalance
		(
			userId,
			creditTypeId,
			credits,
			dateExpiry,
			dateCreated,
			dateModified,
			batchId)
		VALUES
		(
 			@userId,
 			@creditTypeId,
 			@credits,
 			@dateExpiry,
 			@dateCreated,
 			@dateModified,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert CreditBalance where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_CreditBalance INTO
		@userId,
		@creditTypeId,
		@credits,
		@dateExpiry,
		@dateCreated,
		@dateModified,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingCreditBalance
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..CreditBalance
		SET
			userId = @userId,
			creditTypeId = @creditTypeId,
			credits = @credits,
			dateExpiry = @dateExpiry,
			dateCreated = @dateCreated,
			dateModified = @dateModified,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO CreditBalance '

CLOSE cur_CreditBalance
DEALLOCATE CURSOR cur_CreditBalance

--exec p_sumCreditBalance @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcCreditBalance') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcCreditBalance >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcCreditBalance >>>'
go
