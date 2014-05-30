IF OBJECT_ID('dbo.p_arcCreditCard') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcCreditCard
   IF OBJECT_ID('dbo.p_arcCreditCard') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcCreditCard >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcCreditCard >>>'
END
go
CREATE procedure dbo.p_arcCreditCard @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..CreditCard
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- CreditCard
DECLARE @creditCardId   int
DECLARE @userId   numeric(12,0)
DECLARE @cardTypeId   smallint
DECLARE @cardNum	varchar(64)
DECLARE @encodedCardNum	varchar(64)
DECLARE @partialCardNum	char(8)
DECLARE @status	char(1)
DECLARE @nameOnCard	varchar(40)
DECLARE @cardNickname	varchar(40)
DECLARE @country	varchar(24)
DECLARE @countryArea	varchar(32)
DECLARE @city	varchar(32)
DECLARE @address	varchar(80)
DECLARE @zipCode	varchar(10)
DECLARE @cardExpiry	char(4)
DECLARE @cvv	char(3)
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

/* Declare cursor on AccountingLoad..CreditCard */
DECLARE cur_CreditCard CURSOR FOR
SELECT 
	@batchId
	,creditCardId
	,userId
	,cardTypeId
	,cardNum
	,encodedCardNum
	,partialCardNum
	,status
	,nameOnCard
	,cardNickname
	,country
	,countryArea
	,city
	,address
	,zipCode
	,cardExpiry
	,cvv
	,dateCreated
	,dateModified
FROM CreditCard
FOR READ ONLY

OPEN cur_CreditCard
FETCH cur_CreditCard INTO
	@batchId
	,@creditCardId
	,@userId
	,@cardTypeId
	,@cardNum
	,@encodedCardNum
	,@partialCardNum
	,@status
	,@nameOnCard
	,@cardNickname
	,@country
	,@countryArea
	,@city
	,@address
	,@zipCode
	,@cardExpiry
	,@cvv
	,@dateCreated
	,@dateModified

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_CreditCard '
		CLOSE cur_CreditCard
		DEALLOCATE CURSOR cur_CreditCard
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..CreditCard ' */

		INSERT arch_Accounting..CreditCard
		(
			creditCardId,
			userId,
			cardTypeId,
			cardNum,
			encodedCardNum,
			partialCardNum,
			status,
			nameOnCard,
			cardNickname,
			country,
			countryArea,
			city,
			address,
			zipCode,
			cardExpiry,
			cvv,
			dateCreated,
			dateModified,
			batchId)
		VALUES
		(
 			@creditCardId,
 			@userId,
 			@cardTypeId,
 			@cardNum,
 			@encodedCardNum,
 			@partialCardNum,
 			@status,
 			@nameOnCard,
 			@cardNickname,
 			@country,
 			@countryArea,
 			@city,
 			@address,
 			@zipCode,
 			@cardExpiry,
 			@cvv,
 			@dateCreated,
 			@dateModified,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert CreditCard where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_CreditCard INTO
		@creditCardId,
		@userId,
		@cardTypeId,
		@cardNum,
		@encodedCardNum,
		@partialCardNum,
		@status,
		@nameOnCard,
		@cardNickname,
		@country,
		@countryArea,
		@city,
		@address,
		@zipCode,
		@cardExpiry,
		@cvv,
		@dateCreated,
		@dateModified,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingCreditCard
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..CreditCard
		SET
			creditCardId = @creditCardId,
			userId = @userId,
			cardTypeId = @cardTypeId,
			cardNum = @cardNum,
			encodedCardNum = @encodedCardNum,
			partialCardNum = @partialCardNum,
			status = @status,
			nameOnCard = @nameOnCard,
			cardNickname = @cardNickname,
			country = @country,
			countryArea = @countryArea,
			city = @city,
			address = @address,
			zipCode = @zipCode,
			cardExpiry = @cardExpiry,
			cvv = @cvv,
			dateCreated = @dateCreated,
			dateModified = @dateModified,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO CreditCard '

CLOSE cur_CreditCard
DEALLOCATE CURSOR cur_CreditCard

--exec p_sumCreditCard @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcCreditCard') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcCreditCard >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcCreditCard >>>'
go
