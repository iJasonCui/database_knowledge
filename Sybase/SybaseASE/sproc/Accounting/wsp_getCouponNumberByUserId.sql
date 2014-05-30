IF OBJECT_ID('dbo.wsp_getCouponNumberByUserId') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.wsp_getCouponNumberByUserId
   IF OBJECT_ID('dbo.wsp_getCouponNumberByUserId') IS NOT NULL
      PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCouponNumberByUserId >>>'
   ELSE
      PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCouponNumberByUserId >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Yan Liu 
**   Date:         March 10, 2008
**   Description:  retrieve coupon code by userId.  
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getCouponNumberByUserId
   @userId NUMERIC(12, 0)
AS

BEGIN
   SELECT couponNumber, 
          status,
          dateCreated,
          dateModified
     FROM CouponRedemption 
    WHERE userId = @userId

   RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getCouponNumberByUserId TO web
go

IF OBJECT_ID('dbo.wsp_getCouponNumberByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getCouponNumberByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCouponNumberByUserId >>>'
go

EXEC sp_procxmode 'dbo.wsp_getCouponNumberByUserId','unchained'
go
