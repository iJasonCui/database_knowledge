IF OBJECT_ID('dbo.p_arcCardType') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcCardType
   IF OBJECT_ID('dbo.p_arcCardType') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcCardType >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcCardType >>>'
END
go
CREATE procedure dbo.p_arcCardType @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..CardType
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- CardType
DECLARE @cardTypeId   smallint
DECLARE @nicknameContentId   smallint
DECLARE @contentId   smallint
DECLARE @displayOrdinal   smallint

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

/* Declare cursor on AccountingLoad..CardType */
DECLARE cur_CardType CURSOR FOR
SELECT 
	@batchId
	,cardTypeId
	,nicknameContentId
	,contentId
	,displayOrdinal
FROM CardType
FOR READ ONLY

OPEN cur_CardType
FETCH cur_CardType INTO
	@batchId
	,@cardTypeId
	,@nicknameContentId
	,@contentId
	,@displayOrdinal

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_CardType '
		CLOSE cur_CardType
		DEALLOCATE CURSOR cur_CardType
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..CardType ' */

		INSERT arch_Accounting..CardType
		(
			cardTypeId,
			nicknameContentId,
			contentId,
			displayOrdinal,
			batchId)
		VALUES
		(
 			@cardTypeId,
 			@nicknameContentId,
 			@contentId,
 			@displayOrdinal,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert CardType where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_CardType INTO
		@cardTypeId,
		@nicknameContentId,
		@contentId,
		@displayOrdinal,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingCardType
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..CardType
		SET
			cardTypeId = @cardTypeId,
			nicknameContentId = @nicknameContentId,
			contentId = @contentId,
			displayOrdinal = @displayOrdinal,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO CardType '

CLOSE cur_CardType
DEALLOCATE CURSOR cur_CardType

--exec p_sumCardType @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcCardType') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcCardType >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcCardType >>>'
go
