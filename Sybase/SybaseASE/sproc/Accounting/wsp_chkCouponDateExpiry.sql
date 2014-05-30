IF OBJECT_ID('dbo.wsp_chkCouponDateExpiry') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_chkCouponDateExpiry
    IF OBJECT_ID('dbo.wsp_chkCouponDateExpiry') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_chkCouponDateExpiry >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_chkCouponDateExpiry >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Andy Tran
**   Date:  June 2008
**   Description:  check if a purchase was made with the credit card before
**
** REVISION(S):
**   Author:
**   Date: 
**   Description: 
**
******************************************************************************/
CREATE PROCEDURE  wsp_chkCouponDateExpiry
 @couponNumber NUMERIC(10,0)

AS
DECLARE
 @dateNow DATETIME
,@return INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN
    BEGIN TRAN TRAN_chkCouponDateExpiry
        SELECT 1 AS isExpired
          FROM Coupon
         WHERE couponNumber = @couponNumber
           AND dateExpiry IS NOT NULL
           AND dateExpiry < @dateNow

        IF @@error = 0
            BEGIN
                COMMIT TRAN TRAN_chkCouponDateExpiry
            END
        ELSE
            BEGIN
                ROLLBACK TRAN TRAN_chkCouponDateExpiry
            END
END
go

GRANT EXECUTE ON dbo.wsp_chkCouponDateExpiry TO web
go

IF OBJECT_ID('dbo.wsp_chkCouponDateExpiry') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_chkCouponDateExpiry >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_chkCouponDateExpiry >>>'
go

EXEC sp_procxmode 'dbo.wsp_chkCouponDateExpiry','unchained'
go
