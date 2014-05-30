IF OBJECT_ID('dbo.wsp_getCouponTypeIdByNumber') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.wsp_getCouponTypeIdByNumber
   IF OBJECT_ID('dbo.wsp_getCouponTypeIdByNumber') IS NOT NULL
      PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCouponTypeIdByNumber >>>'
   ELSE
      PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCouponTypeIdByNumber >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Yan Liu 
**   Date:         March 10, 2008
**   Description:  retrieve coupon info by coupon number 
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getCouponTypeIdByNumber
   @couponNumber NUMERIC(10, 0)
AS

BEGIN
   SELECT couponTypeId, 
          status,
          dateCreated,
          dateModified
     FROM Coupon 
    WHERE couponNumber = @couponNumber

   RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getCouponTypeIdByNumber TO web
go

IF OBJECT_ID('dbo.wsp_getCouponTypeIdByNumber') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getCouponTypeIdByNumber >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCouponTypeIdByNumber >>>'
go

EXEC sp_procxmode 'dbo.wsp_getCouponTypeIdByNumber','unchained'
go
