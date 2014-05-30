IF OBJECT_ID('dbo.p_arcLocale') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcLocale
   IF OBJECT_ID('dbo.p_arcLocale') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcLocale >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcLocale >>>'
END
go
CREATE procedure dbo.p_arcLocale @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..Locale
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- Locale
DECLARE @localeId   smallint
DECLARE @isoDesc	char(6)

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

/* Declare cursor on AccountingLoad..Locale */
DECLARE cur_Locale CURSOR FOR
SELECT 
	@batchId
	,localeId
	,isoDesc
FROM Locale
FOR READ ONLY

OPEN cur_Locale
FETCH cur_Locale INTO
	@batchId
	,@localeId
	,@isoDesc

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_Locale '
		CLOSE cur_Locale
		DEALLOCATE CURSOR cur_Locale
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..Locale ' */

		INSERT arch_Accounting..Locale
		(
			localeId,
			isoDesc,
			batchId)
		VALUES
		(
 			@localeId,
 			@isoDesc,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert Locale where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_Locale INTO
		@localeId,
		@isoDesc,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingLocale
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..Locale
		SET
			localeId = @localeId,
			isoDesc = @isoDesc,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO Locale '

CLOSE cur_Locale
DEALLOCATE CURSOR cur_Locale

--exec p_sumLocale @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcLocale') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcLocale >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcLocale >>>'
go
