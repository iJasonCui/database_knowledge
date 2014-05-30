IF OBJECT_ID('dbo.wsp_getMembAccTranHistForMemb') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMembAccTranHistForMemb
    IF OBJECT_ID('dbo.wsp_getMembAccTranHistForMemb') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMembAccTranHistForMemb >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMembAccTranHistForMemb >>>'
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
**   Author:       Malay Dave
**   Date:         Feb 19, 2004
**   Description:  1. Fixed bug - proc was getting currencyId instead of billingLocationId
**                 2. Getting purchaseOfferDetailId to Member as well
**
**   Author:       Andy Tran
**   Date:         December 2005
**   Description:  retrieves currency as well
**                 re-suffle to make field orders the same with admin history
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getMembAccTranHistForMemb
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
          ,cost =
            CASE pd.cost 
               WHEN null THEN p.cost 
               ELSE pd.cost 
            END
          ,tax =
            CASE pd.tax 
               WHEN null THEN p.tax 
               ELSE pd.tax
            END
          ,a.description
          ,p.billingLocationId
          ,p.purchaseOfferDetailId
          ,p.purchaseTypeId
          ,p.currencyId
      FROM AccountTransaction a ( INDEX XAK1AccountTransaction) , PurchaseCreditDetail pd, Purchase p
     WHERE a.userId = @userId
       AND a.xactionId *= p.xactionId
       AND p.xactionId *= pd.xactionId
       AND a.dateCreated >= @dateCreated
    
    ORDER BY xactionId
    AT ISOLATION READ UNCOMMITTED

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getMembAccTranHistForMemb TO web
go

IF OBJECT_ID('dbo.wsp_getMembAccTranHistForMemb') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getMembAccTranHistForMemb >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMembAccTranHistForMemb >>>'
go

EXEC sp_procxmode 'dbo.wsp_getMembAccTranHistForMemb','unchained'
go
