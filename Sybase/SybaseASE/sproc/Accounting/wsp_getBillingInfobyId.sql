USE Accounting
go

IF OBJECT_ID('dbo.wsp_getBillingInfobyId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getBillingInfobyId
    IF OBJECT_ID('dbo.wsp_getBillingInfobyId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getBillingInfobyId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getBillingInfobyId >>>'
END
go
/******************************************************************************

**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getBillingInfobyId
   @billingLocationId INT
AS
   BEGIN  
      SELECT billingLocationDesc,
             billingLocationCode
        FROM BillingLocation 
       WHERE billingLocationId = @billingLocationId

      RETURN @@error
   END
go

EXEC sp_procxmode 'dbo.wsp_getBillingInfobyId','unchained'
go

IF OBJECT_ID('dbo.wsp_getBillingInfobyId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getBillingInfobyId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getBillingInfobyId >>>'
go
GRANT EXECUTE ON dbo.wsp_getBillingInfobyId TO web
go
