IF OBJECT_ID('dbo.wsp_updUserUsageCell') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updUserUsageCell
    IF OBJECT_ID('dbo.wsp_updUserUsageCell') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updUserUsageCell >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updUserUsageCell >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  May 21, 2003
**   Description:  updates user offer
**
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: November 2004
**   Description: added dateExpiry
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_updUserUsageCell
@userId            NUMERIC(12,0),
@usageCellId       SMALLINT,
@dateExpiry        DATETIME
AS
  DECLARE  @dateModified   DATETIME,
           @return 	  INT  
        
  EXEC @return = dbo.wsp_GetDateGMT @dateModified OUTPUT
     
  IF @return != 0
  BEGIN
      RETURN @return
  END

  BEGIN TRAN TRAN_updUserUsageCell
            BEGIN
              UPDATE UserAccount
              SET usageCellId = @usageCellId,
                  dateModified = @dateModified,
                  dateExpiry = @dateExpiry
              WHERE userId = @userId

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
                         dateModified, 
                         dateExpiry, 
                         subscriptionOfferId)
                  SELECT userId, 
                         billingLocationId, 
                         purchaseOfferId, 
                         usageCellId, 
                         accountType, 
                         dateCreated, 
                         dateModified, 
                         dateExpiry, 
                         subscriptionOfferId 
                  FROM UserAccount 
                  WHERE userId = @userId	    

	      IF @@error = 0
			BEGIN
				COMMIT TRAN TRAN_updUserUsageCell
				RETURN 0
			END
	      ELSE
			BEGIN
				ROLLBACK TRAN TRAN_updUserUsageCell
				RETURN 98
			END
         END
go
IF OBJECT_ID('dbo.wsp_updUserUsageCell') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updUserUsageCell >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updUserUsageCell >>>'
go
GRANT EXECUTE ON dbo.wsp_updUserUsageCell TO web
go


