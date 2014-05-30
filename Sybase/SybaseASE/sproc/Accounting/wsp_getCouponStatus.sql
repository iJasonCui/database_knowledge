IF OBJECT_ID('dbo.wsp_getCouponStatus') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.wsp_getCouponStatus
   IF OBJECT_ID('dbo.wsp_getCouponStatus') IS NOT NULL
      PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCouponStatus >>>'
   ELSE
      PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCouponStatus >>>'
END
go

CREATE PROCEDURE dbo.wsp_getCouponStatus
   @userId NUMERIC(12, 0),
   @couponNumber NUMERIC(12, 0)
AS

BEGIN
   SELECT status
   FROM CouponRedemption 
   WHERE userId = @userId and couponNumber=@couponNumber

   RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getCouponStatus TO web
go

IF OBJECT_ID('dbo.wsp_getCouponStatus') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getCouponStatus >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCouponStatus >>>'
go

EXEC sp_procxmode 'dbo.wsp_getCouponStatus','unchained'
go
