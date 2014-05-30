IF OBJECT_ID('dbo.wsp_getMembAccTranHistForAdmin') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMembAccTranHistForAdmin
    IF OBJECT_ID('dbo.wsp_getMembAccTranHistForAdmin') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMembAccTranHistForAdmin >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMembAccTranHistForAdmin >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Mark Jaeckle
**   Date:         Sept 5, 2003
**   Description:  retrieves account transactions for the specified user
**
**
** REVISION(S):
**   Author:       Andy Tran
**   Date:         December 2005
**   Description:  retrieves currency as well
**                 re-suffle to make field orders the same with member history
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getMembAccTranHistForAdmin
     @userId NUMERIC(12,0)
    ,@dateCreated DATETIME
AS

BEGIN
    SELECT a.xactionId
          ,a.xactionTypeId
          ,a.creditTypeId
          ,a.contentId
          ,a.credits
          ,a.balance
          ,a.dateCreated
          ,p.cost
          ,p.tax
          ,a.description
          ,p.billingLocationId
          ,p.purchaseOfferDetailId
          ,p.purchaseTypeId
          ,p.currencyId
          ,admin.adminUserId
          ,p.paymentNumber
          ,p.creditCardId
      FROM AccountTransaction a ( INDEX XAK1AccountTransaction) , Purchase p, AdminAccountTransaction admin
     WHERE a.userId = @userId
       AND a.xactionId *= p.xactionId
       AND a.xactionId *= admin.xactionId
       AND a.dateCreated >= @dateCreated
    
    ORDER BY xactionId
    AT ISOLATION READ UNCOMMITTED

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getMembAccTranHistForAdmin TO web
go

IF OBJECT_ID('dbo.wsp_getMembAccTranHistForAdmin') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getMembAccTranHistForAdmin >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMembAccTranHistForAdmin >>>'
go

EXEC sp_procxmode 'dbo.wsp_getMembAccTranHistForAdmin','unchained'
go
