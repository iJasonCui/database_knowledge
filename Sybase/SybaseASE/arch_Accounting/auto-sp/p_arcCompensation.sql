IF OBJECT_ID('dbo.p_arcCompensation') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcCompensation
   IF OBJECT_ID('dbo.p_arcCompensation') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcCompensation >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcCompensation >>>'
END
go
CREATE procedure dbo.p_arcCompensation @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..Compensation
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- Compensation
DECLARE @compensationId   int
DECLARE @usageTypeId   tinyint
DECLARE @adminUserId   int
DECLARE @userCount   int
DECLARE @creditCount   int
DECLARE @compensationDesc	varchar(255)
DECLARE @dateCompensated   datetime
DECLARE @dateUnavailableFrom   datetime
DECLARE @dateUnavailableTo   datetime
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

/* Declare cursor on AccountingLoad..Compensation */
DECLARE cur_Compensation CURSOR FOR
SELECT 
	@batchId
	,compensationId
	,usageTypeId
	,adminUserId
	,userCount
	,creditCount
	,compensationDesc
	,dateCompensated
	,dateUnavailableFrom
	,dateUnavailableTo
	,dateCreated
FROM Compensation
FOR READ ONLY

OPEN cur_Compensation
FETCH cur_Compensation INTO
	@batchId
	,@compensationId
	,@usageTypeId
	,@adminUserId
	,@userCount
	,@creditCount
	,@compensationDesc
	,@dateCompensated
	,@dateUnavailableFrom
	,@dateUnavailableTo
	,@dateCreated

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_Compensation '
		CLOSE cur_Compensation
		DEALLOCATE CURSOR cur_Compensation
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..Compensation ' */

		INSERT arch_Accounting..Compensation
		(
			compensationId,
			usageTypeId,
			adminUserId,
			userCount,
			creditCount,
			compensationDesc,
			dateCompensated,
			dateUnavailableFrom,
			dateUnavailableTo,
			dateCreated,
			batchId)
		VALUES
		(
 			@compensationId,
 			@usageTypeId,
 			@adminUserId,
 			@userCount,
 			@creditCount,
 			@compensationDesc,
 			@dateCompensated,
 			@dateUnavailableFrom,
 			@dateUnavailableTo,
 			@dateCreated,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert Compensation where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_Compensation INTO
		@compensationId,
		@usageTypeId,
		@adminUserId,
		@userCount,
		@creditCount,
		@compensationDesc,
		@dateCompensated,
		@dateUnavailableFrom,
		@dateUnavailableTo,
		@dateCreated,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingCompensation
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..Compensation
		SET
			compensationId = @compensationId,
			usageTypeId = @usageTypeId,
			adminUserId = @adminUserId,
			userCount = @userCount,
			creditCount = @creditCount,
			compensationDesc = @compensationDesc,
			dateCompensated = @dateCompensated,
			dateUnavailableFrom = @dateUnavailableFrom,
			dateUnavailableTo = @dateUnavailableTo,
			dateCreated = @dateCreated,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO Compensation '

CLOSE cur_Compensation
DEALLOCATE CURSOR cur_Compensation

--exec p_sumCompensation @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcCompensation') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcCompensation >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcCompensation >>>'
go
