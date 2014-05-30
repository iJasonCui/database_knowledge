IF OBJECT_ID('dbo.wsp_saveCreditBalance') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveCreditBalance
    IF OBJECT_ID('dbo.wsp_saveCreditBalance') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveCreditBalance >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveCreditBalance >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:  Yan Liu 
**   Date:  January 15 2009 
**   Description:  save credit balance. 
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_saveCreditBalance
   @userId       NUMERIC(12, 0),
   @credits      SMALLINT,
   @creditTypeId TINYINT,
   @dateExpiry   DATETIME
AS

BEGIN
   DECLARE @return  INT
   DECLARE @dateNow DATETIME

   EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT

   IF (@dateExpiry IS NULL)
   BEGIN
      SELECT @dateExpiry = 'Dec 31 12:00:00AM 2052'
   END

   BEGIN TRAN TRAN_saveCreditBalance
   IF EXISTS(SELECT 1 FROM CreditBalance 
              WHERE userId = @userId 
                AND creditTypeId = @creditTypeId)
      BEGIN
         UPDATE CreditBalance
            SET credits = credits + @credits,
                dateModified = @dateNow,
                dateExpiry = @dateExpiry
          WHERE userId = @userId 
            AND creditTypeId = @creditTypeId

         IF (@@error = 0)
            BEGIN
               COMMIT TRAN TRAN_saveCreditBalance
            END
         ELSE
            BEGIN
               ROLLBACK TRAN TRAN_saveCreditBalance
               RETURN 99
            END
      END
   ELSE 
      BEGIN
         INSERT INTO CreditBalance(userId,
                                   creditTypeId,
                                   credits,
                                   dateExpiry,
                                   dateModified,
                                   dateCreated)
         VALUES(@userId,
                @creditTypeId,
                @credits,
                @dateExpiry,
                @dateNow,
                @dateNow)

         IF (@@error = 0)
            BEGIN
               COMMIT TRAN TRAN_saveCreditBalance
            END
         ELSE
            BEGIN
               ROLLBACK TRAN TRAN_saveCreditBalance
               RETURN 98
            END
      END

   RETURN 0
END
go

IF OBJECT_ID('dbo.wsp_saveCreditBalance') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_saveCreditBalance >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveCreditBalance >>>'
go

GRANT EXECUTE ON dbo.wsp_saveCreditBalance TO web
go

