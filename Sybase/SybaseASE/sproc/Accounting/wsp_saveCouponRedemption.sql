IF OBJECT_ID('dbo.wsp_saveCouponRedemption') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveCouponRedemption
    IF OBJECT_ID('dbo.wsp_saveCouponRedemption') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveCouponRedemption >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveCouponRedemption >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Yan Liu 
**   Date:  March 10 2008
**   Description:  save CouponRedemption data
**
** REVISION(S):
**   Author: 
**   Date:
**   Description: 
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_saveCouponRedemption
   @couponNumber NUMERIC(10, 0),
   @userId       NUMERIC(12, 0),
   @status       CHAR(1)
AS

BEGIN
   DECLARE @dateNow DATETIME,
           @return  INT

   EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
   IF (@return != 0)
   BEGIN
      RETURN @return
   END

   IF NOT EXISTS(SELECT 1 FROM CouponRedemption 
                  WHERE couponNumber = @couponNumber
                    AND userId = @userId)
      BEGIN
         BEGIN TRAN TRAN_saveCouponRedemption

         INSERT INTO CouponRedemption(couponNumber, 
                                      userId, 
                                      status, 
                                      dateCreated, 
                                      dateModified)
         VALUES(@couponNumber, 
                @userId, 
                @status, 
                @dateNow,
                @dateNow)
         
         IF (@@error = 0)
            BEGIN
               COMMIT TRAN TRAN_saveCouponRedemption
               RETURN 0
            END
         ELSE
            BEGIN
               ROLLBACK TRAN TRAN_saveCouponRedemption
               RETURN 99
            END
      END 
   ELSE
      BEGIN
         BEGIN TRAN TRAN_saveCouponRedemption
         UPDATE CouponRedemption 
            SET status = @status,
                dateModified = @dateNow
          WHERE couponNumber = @couponNumber
            AND userId = @userId

         IF (@@error = 0)
            BEGIN
               COMMIT TRAN TRAN_saveCouponRedemption
               RETURN 0
            END
         ELSE
            BEGIN
               ROLLBACK TRAN TRAN_saveCouponRedemption
               RETURN 98
            END
      END
END
go

GRANT EXECUTE ON dbo.wsp_saveCouponRedemption TO web
go

IF OBJECT_ID('dbo.wsp_saveCouponRedemption') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_saveCouponRedemption >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveCouponRedemption >>>'
go

EXEC sp_procxmode 'dbo.wsp_saveCouponRedemption', 'unchained'
go
