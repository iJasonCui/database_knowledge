IF OBJECT_ID('dbo.wsp_newUserAccount') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newUserAccount
    IF OBJECT_ID('dbo.wsp_newUserAccount') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newUserAccount >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newUserAccount >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  May 21, 2003
**   Description:  creates new user account info
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_newUserAccount
 @userId            NUMERIC(12,0)
,@billingLocationId SMALLINT
,@accountType       CHAR(1)
,@purchaseOfferId   SMALLINT
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

		BEGIN TRAN TRAN_newUserAccount

            INSERT INTO UserAccount 
               (userId, 
                billingLocationId, 
                purchaseOfferId,
                usageCellId,
                accountType, 
                dateCreated,
                dateModified)
            VALUES 
               (@userId,
                @billingLocationId,
                @purchaseOfferId,
                @usageCellId,
                @accountType,
                @dateCreated,
                @dateCreated)


              IF @@error != 0
	        BEGIN
	   	   ROLLBACK TRAN TRAN_updUserAccount
		   RETURN 98
	        END

            INSERT INTO UserAccountHistory 
               (userId, 
                billingLocationId, 
                purchaseOfferId,
                usageCellId,
                accountType, 
                dateCreated,
                dateModified)
            VALUES 
               (@userId,
                @billingLocationId,
                @purchaseOfferId,
                @usageCellId,
                @accountType,
                @dateCreated,
                @dateCreated)



			IF @@error = 0
				BEGIN
					COMMIT TRAN TRAN_newUserAccount
					RETURN 0
				END
			ELSE
				BEGIN
					ROLLBACK TRAN TRAN_newUserAccount
					RETURN 98
				END
	END
go
IF OBJECT_ID('dbo.wsp_newUserAccount') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newUserAccount >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newUserAccount >>>'
go
GRANT EXECUTE ON dbo.wsp_newUserAccount TO web
go
