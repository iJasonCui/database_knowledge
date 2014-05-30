IF OBJECT_ID('dbo.wsp_getSDTransactions') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getSDTransactions
    IF OBJECT_ID('dbo.wsp_getSDTransactions') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getSDTransactions >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getSDTransactions >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         June 1, 2009
**   Description:  Retrieves all SD transactions for user in the period
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getSDTransactions
 @userId  NUMERIC(12,0)
,@cutoff  DATETIME
AS
BEGIN  

DECLARE
 @return   INT


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
      FROM AccountTransaction a ( INDEX XAK1AccountTransaction) , Purchase p
     WHERE a.userId = @userId
       AND a.xactionId *= p.xactionId
       AND a.dateCreated >= @dateCreated

    SELECT t.xactionId
          ,t.xactionTypeId
          ,t.eventId
       AND t.xactionId *= p.xactionId
       AND a.dateCreated >= @cutoff
    ORDER BY xactionId ASC
    AT ISOLATION READ UNCOMMITTED

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getSDTransactions TO web
go

IF OBJECT_ID('dbo.wsp_getSDTransactions') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getSDTransactions >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getSDTransactions >>>'
go

EXEC sp_procxmode 'dbo.wsp_getSDTransactions','unchained'
go
