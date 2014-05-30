IF OBJECT_ID('dbo.p_arcLocaleContent') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcLocaleContent
   IF OBJECT_ID('dbo.p_arcLocaleContent') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcLocaleContent >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcLocaleContent >>>'
END
go
CREATE procedure dbo.p_arcLocaleContent @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..LocaleContent
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- LocaleContent
DECLARE @localeId   smallint
DECLARE @contentId   smallint
DECLARE @contentText	varchar(255)

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

/* Declare cursor on AccountingLoad..LocaleContent */
DECLARE cur_LocaleContent CURSOR FOR
SELECT 
	@batchId
	,localeId
	,contentId
	,contentText
FROM LocaleContent
FOR READ ONLY

OPEN cur_LocaleContent
FETCH cur_LocaleContent INTO
	@batchId
	,@localeId
	,@contentId
	,@contentText

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_LocaleContent '
		CLOSE cur_LocaleContent
		DEALLOCATE CURSOR cur_LocaleContent
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..LocaleContent ' */

		INSERT arch_Accounting..LocaleContent
		(
			localeId,
			contentId,
			contentText,
			batchId)
		VALUES
		(
 			@localeId,
 			@contentId,
 			@contentText,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert LocaleContent where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_LocaleContent INTO
		@localeId,
		@contentId,
		@contentText,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingLocaleContent
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..LocaleContent
		SET
			localeId = @localeId,
			contentId = @contentId,
			contentText = @contentText,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO LocaleContent '

CLOSE cur_LocaleContent
DEALLOCATE CURSOR cur_LocaleContent

--exec p_sumLocaleContent @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcLocaleContent') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcLocaleContent >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcLocaleContent >>>'
go
