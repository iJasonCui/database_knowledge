IF OBJECT_ID('dbo.p_arcSubscriptionEligibility') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.p_arcSubscriptionEligibility
   IF OBJECT_ID('dbo.p_arcSubscriptionEligibility') IS NOT NULL
       PRINT '<<< FAILED DROPPING PROCEDURE dbo.p_arcSubscriptionEligibility >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.p_arcSubscriptionEligibility >>>'
END
go
CREATE procedure dbo.p_arcSubscriptionEligibility @batchId int,@fileId int,@fileDate int
AS
BEGIN

/******************************************************************************
**
** CREATION:
**   Author:      Jason Cui
**   Date:        Nov 11 2003
**   Description: insert data to arch_Accounting..SubscriptionEligibility
**
** REVISION(S): --Author:--   Date:--   Description:
**
******************************************************************************/

--Declare Local Variable -- SubscriptionEligibility
DECLARE @eligibilityId   smallint
DECLARE @subscriptionOfferId   smallint
DECLARE @localeId   tinyint
DECLARE @billingLocationId   smallint
DECLARE @cityId   int
DECLARE @jurisdictionId   smallint
DECLARE @secondJurisdictionId   smallint
DECLARE @countryId   smallint
DECLARE @product	char(4)
DECLARE @community	char(4)
DECLARE @userType	char(1)
DECLARE @brand	char(2)
DECLARE @gender	char(1)
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

/* Declare cursor on AccountingLoad..SubscriptionEligibility */
DECLARE cur_SubscriptionEligibility CURSOR FOR
SELECT 
	@batchId
	,eligibilityId
	,subscriptionOfferId
	,localeId
	,billingLocationId
	,cityId
	,jurisdictionId
	,secondJurisdictionId
	,countryId
	,product
	,community
	,userType
	,brand
	,gender
	,dateCreated
	,dateModified
FROM SubscriptionEligibility
FOR READ ONLY

OPEN cur_SubscriptionEligibility
FETCH cur_SubscriptionEligibility INTO
	@batchId
	,@eligibilityId
	,@subscriptionOfferId
	,@localeId
	,@billingLocationId
	,@cityId
	,@jurisdictionId
	,@secondJurisdictionId
	,@countryId
	,@product
	,@community
	,@userType
	,@brand
	,@gender
	,@dateCreated
	,@dateModified

WHILE (@@sqlstatus != 2)
BEGIN
	IF (@@sqlstatus = 1)
	BEGIN
		PRINT 'Msg error: failed during fetching data from cursor cur_SubscriptionEligibility '
		CLOSE cur_SubscriptionEligibility
		DEALLOCATE CURSOR cur_SubscriptionEligibility
		RETURN
	END
	ELSE BEGIN

		/* PRINT 'archieving data into arch_Accounting..SubscriptionEligibility ' */

		INSERT arch_Accounting..SubscriptionEligibility
		(
			eligibilityId,
			subscriptionOfferId,
			localeId,
			billingLocationId,
			cityId,
			jurisdictionId,
			secondJurisdictionId,
			countryId,
			product,
			community,
			userType,
			brand,
			gender,
			dateCreated,
			dateModified,
			batchId)
		VALUES
		(
 			@eligibilityId,
 			@subscriptionOfferId,
 			@localeId,
 			@billingLocationId,
 			@cityId,
 			@jurisdictionId,
 			@secondJurisdictionId,
 			@countryId,
 			@product,
 			@community,
 			@userType,
 			@brand,
 			@gender,
 			@dateCreated,
 			@dateModified,
			@batchId)

		IF @@error != 0
		BEGIN
			SELECT @errorMessage = 'Msg error: failed when insert SubscriptionEligibility where addressId= convert(varchar(20),@addressId)'
			PRINT @errorMessage
		END

	END
	FETCH cur_SubscriptionEligibility INTO
		@eligibilityId,
		@subscriptionOfferId,
		@localeId,
		@billingLocationId,
		@cityId,
		@jurisdictionId,
		@secondJurisdictionId,
		@countryId,
		@product,
		@community,
		@userType,
		@brand,
		@gender,
		@dateCreated,
		@dateModified,
		@batchId
END /* END OF WHILE */

/*
-- update data of DataLoadLog..BatchLog 
SELECT @dateCreatedFrom = min(dateCreated),@dateCreatedTo = max(dateCreated)
FROM arch_AccoutingSubscriptionEligibility
WHERE batchId = @batchId
EXEC DB_LOG..p_update_BatchLog_SP 
@batchId,@rowCountArchived,@rowCountReport,@dateCreatedFrom,@dateCreatedTo
		UPDATE arch_Accounting..SubscriptionEligibility
		SET
			eligibilityId = @eligibilityId,
			subscriptionOfferId = @subscriptionOfferId,
			localeId = @localeId,
			billingLocationId = @billingLocationId,
			cityId = @cityId,
			jurisdictionId = @jurisdictionId,
			secondJurisdictionId = @secondJurisdictionId,
			countryId = @countryId,
			product = @product,
			community = @community,
			userType = @userType,
			brand = @brand,
			gender = @gender,
			dateCreated = @dateCreated,
			dateModified = @dateModified,
*/

PRINT 'NO MORE DATA TO BE ARCHIVED TO SubscriptionEligibility '

CLOSE cur_SubscriptionEligibility
DEALLOCATE CURSOR cur_SubscriptionEligibility

--exec p_sumSubscriptionEligibility @batchId,@fileId,@fileDate

END /* END OF PROCEDURE */
go
IF OBJECT_ID('dbo.p_arcSubscriptionEligibility') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.p_arcSubscriptionEligibility >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.p_arcSubscriptionEligibility >>>'
go
