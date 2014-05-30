IF OBJECT_ID('dbo.wsp_newWSUserAccount') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newWSUserAccount
    IF OBJECT_ID('dbo.wsp_newWSUserAccount') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newWSUserAccount >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newWSUserAccount >>>'
END
go
/******************************************************************************
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_newWSUserAccount
 @userId            NUMERIC(12,0)
,@billingLocationId SMALLINT
,@accountType       CHAR(1)
,@purchaseOfferId   SMALLINT
,@subscriptionOfferId  SMALLINT
,@usageCellId       SMALLINT
AS
DECLARE @dateCreated DATETIME
,@return INT  
        
EXEC @return = dbo.wsp_GetDateGMT @dateCreated OUTPUT
     
IF @return != 0
	BEGIN
		RETURN @return
	END

IF NOT EXISTS (SELECT 1 FROM UserAccount WHERE userId = @userId)

	BEGIN

		BEGIN TRAN TRAN_newWSUserAccount

            INSERT INTO UserAccount 
               (userId, 
                billingLocationId, 
                purchaseOfferId,
                subscriptionOfferId,
                usageCellId,
                accountType, 
                dateCreated,
                dateModified)
            VALUES 
               (@userId,
                @billingLocationId,
                @purchaseOfferId,
                @subscriptionOfferId,
                @usageCellId,
                @accountType,
                @dateCreated,
                @dateCreated)


              IF @@error != 0
	        BEGIN
	   	   ROLLBACK TRAN TRAN_newWSUserAccount
		   RETURN 98
	        END

            INSERT INTO UserAccountHistory 
               (userId, 
                billingLocationId, 
                purchaseOfferId,
                subscriptionOfferId,
                usageCellId,
                accountType, 
                dateCreated,
                dateModified)
            VALUES 
               (@userId,
                @billingLocationId,
                @purchaseOfferId,
                @subscriptionOfferId,
                @usageCellId,
                @accountType,
                @dateCreated,
                @dateCreated)

			IF @@error = 0
				BEGIN
					COMMIT TRAN TRAN_newWSUserAccount
					RETURN 0
				END
			ELSE
				BEGIN
					ROLLBACK TRAN TRAN_newWSUserAccount
					RETURN 98
				END
	END
go
IF OBJECT_ID('dbo.wsp_newWSUserAccount') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newWSUserAccount >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newWSUserAccount >>>'
go
GRANT EXECUTE ON dbo.wsp_newWSUserAccount TO web
go
