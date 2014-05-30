IF OBJECT_ID('dbo.wsp_updUserSubscriptionOffer') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updUserSubscriptionOffer
    IF OBJECT_ID('dbo.wsp_updUserSubscriptionOffer') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updUserSubscriptionOffer >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updUserSubscriptionOffer >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  November 24, 2005
**   Description:  updates user subscription offer
**
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_updUserSubscriptionOffer
@userId                NUMERIC(12,0),
@subscriptionOfferId   SMALLINT,
@accountType           CHAR(1)
AS
  DECLARE  @dateModified  DATETIME,
           @return 	  INT  
        
  EXEC @return = dbo.wsp_GetDateGMT @dateModified OUTPUT
     
  IF @return != 0
  BEGIN
      RETURN @return
  END

  BEGIN TRAN TRAN_updUserSubscriptionOffer

  UPDATE UserAccount
  SET subscriptionOfferId = @subscriptionOfferId,
      accountType = @accountType,
      dateModified = @dateModified
  WHERE userId = @userId

  IF @@error != 0
	BEGIN
		ROLLBACK TRAN TRAN_updUserAccount
		RETURN 98
	END

  INSERT INTO UserAccountHistory SELECT 
    userId,
    billingLocationId,
    purchaseOfferId,
    usageCellId,
    accountType,
    dateCreated,
    dateModified,
    dateExpiry,
    subscriptionOfferId
  FROM UserAccount WHERE userId = @userId	    

  IF @@error = 0
	BEGIN
		COMMIT TRAN TRAN_updUserSubscriptionOffer
		RETURN 0
	END
  ELSE
	BEGIN
		ROLLBACK TRAN TRAN_updUserSubscriptionOffer
		RETURN 98
	END
go
IF OBJECT_ID('dbo.wsp_updUserSubscriptionOffer') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updUserSubscriptionOffer >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updUserSubscriptionOffer >>>'
go
GRANT EXECUTE ON dbo.wsp_updUserSubscriptionOffer TO web
go

