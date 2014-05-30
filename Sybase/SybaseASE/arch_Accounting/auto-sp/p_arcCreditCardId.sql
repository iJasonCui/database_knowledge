IF OBJECT_ID('dbo.p_arcCreditCardId') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcCreditCardId
   IF OBJECT_ID('dbo.p_arcCreditCardId') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcCreditCardId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcCreditCardId >>>'
END
go
CREATE procedure dbo.p_arcCreditCardId @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..CreditCardId
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- CreditCardId
DECLARE @creditCardId   int

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

/* Declare cursor on AccountingLoad..CreditCardId */
DECLARE cur_CreditCardId CURSOR FOR
SELECT 
	@batchId
	,creditCardId
FROM CreditCardId
FOR READ ONLY

OPEN cur_CreditCardId
FETCH cur_CreditCardId INTO
	@batchId
	,@creditCardId

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_CreditCardId '
		CLOSE cur_CreditCardId
		DEALLOCATE CURSOR cur_CreditCardId
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..CreditCardId ' */

		INSERT arch_Accounting..CreditCardId
		(
			creditCardId,
			batchId)
		VALUES
		(
 			@creditCardId,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert CreditCardId where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_CreditCardId INTO
		@creditCardId,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingCreditCardId
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..CreditCardId
		SET
			creditCardId = @creditCardId,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO CreditCardId '

CLOSE cur_CreditCardId
DEALLOCATE CURSOR cur_CreditCardId

--exec p_sumCreditCardId @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcCreditCardId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcCreditCardId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcCreditCardId >>>'
go
