IF OBJECT_ID('dbo.p_arcCreditType') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcCreditType
   IF OBJECT_ID('dbo.p_arcCreditType') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcCreditType >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcCreditType >>>'
END
go
CREATE procedure dbo.p_arcCreditType @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..CreditType
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- CreditType
DECLARE @creditTypeId   smallint
DECLARE @contentId   smallint
DECLARE @ordinal   tinyint
DECLARE @duration   tinyint

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

/* Declare cursor on AccountingLoad..CreditType */
DECLARE cur_CreditType CURSOR FOR
SELECT 
	@batchId
	,creditTypeId
	,contentId
	,ordinal
	,duration
FROM CreditType
FOR READ ONLY

OPEN cur_CreditType
FETCH cur_CreditType INTO
	@batchId
	,@creditTypeId
	,@contentId
	,@ordinal
	,@duration

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_CreditType '
		CLOSE cur_CreditType
		DEALLOCATE CURSOR cur_CreditType
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..CreditType ' */

		INSERT arch_Accounting..CreditType
		(
			creditTypeId,
			contentId,
			ordinal,
			duration,
			batchId)
		VALUES
		(
 			@creditTypeId,
 			@contentId,
 			@ordinal,
 			@duration,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert CreditType where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_CreditType INTO
		@creditTypeId,
		@contentId,
		@ordinal,
		@duration,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingCreditType
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..CreditType
		SET
			creditTypeId = @creditTypeId,
			contentId = @contentId,
			ordinal = @ordinal,
			duration = @duration,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO CreditType '

CLOSE cur_CreditType
DEALLOCATE CURSOR cur_CreditType

--exec p_sumCreditType @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcCreditType') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcCreditType >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcCreditType >>>'
go
