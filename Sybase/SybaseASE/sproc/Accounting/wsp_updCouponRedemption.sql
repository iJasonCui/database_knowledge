IF OBJECT_ID('dbo.wsp_updCouponRedemption') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updCouponRedemption
    IF OBJECT_ID('dbo.wsp_updCouponRedemption') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updCouponRedemption >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updCouponRedemption >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Yan Liu 
**   Date:  March 10 2008
**   Description:  update CouponRedemption data
**
** REVISION(S):
**   Author: 
**   Date:
**   Description: 
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_updCouponRedemption
   @userId NUMERIC(12, 0),
   @status CHAR(1)
AS

BEGIN
   DECLARE @dateNow DATETIME,
           @return  INT

   EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
   IF (@return != 0)
   BEGIN
      RETURN @return
   END

   IF EXISTS(SELECT 1 FROM CouponRedemption 
              WHERE userId = @userId)
      BEGIN
         BEGIN TRAN TRAN_updCouponRedemption
         UPDATE CouponRedemption 
            SET status = @status,
                dateModified = @dateNow
          WHERE userId = @userId

         IF (@@error = 0)
            BEGIN
               COMMIT TRAN TRAN_updCouponRedemption
               RETURN 0
            END
         ELSE
            BEGIN
               ROLLBACK TRAN TRAN_updCouponRedemption
               RETURN 99
            END
      END
END
go

GRANT EXECUTE ON dbo.wsp_updCouponRedemption TO web
go

IF OBJECT_ID('dbo.wsp_updCouponRedemption') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updCouponRedemption >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updCouponRedemption >>>'
go

EXEC sp_procxmode 'dbo.wsp_updCouponRedemption', 'unchained'
go
