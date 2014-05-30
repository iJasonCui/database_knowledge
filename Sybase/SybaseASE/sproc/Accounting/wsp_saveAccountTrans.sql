IF OBJECT_ID('dbo.wsp_saveAccountTrans') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveAccountTrans
    IF OBJECT_ID('dbo.wsp_saveAccountTrans') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveAccountTrans >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveAccountTrans >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:  Yan Liu 
**   Date:  January 15 2009 
**   Description:  save AccountTransaction.
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_saveAccountTrans
   @xactionId     INT,
   @userId        NUMERIC(12, 0),
   @xactionTypeId TINYINT,
   @creditTypeId  TINYINT, 
   @contentId     SMALLINT,
   @credits       SMALLINT,
   @balance       INT,
   @userType      CHAR(1)
AS

BEGIN
   DECLARE @return  INT
   DECLARE @dateNow DATETIME

   EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT

   IF NOT EXISTS(SELECT 1 FROM AccountTransaction WHERE xactionId = @xactionId) 
      BEGIN
         BEGIN TRAN TRAN_saveAccountTrans
         INSERT INTO AccountTransaction(xactionId,
                                        userId,
                                        xactionTypeId,
                                        creditTypeId,
                                        contentId,
                                        credits,
                                        balance,
                                        userType,
                                        dateCreated)
        VALUES(@xactionId,
               @userId,
               @xactionTypeId,
               @creditTypeId,
               @contentId,
               @credits,
               @balance,
               @userType,
               @dateNow)

         IF (@@error = 0)
            BEGIN
               COMMIT TRAN TRAN_saveAccountTrans
            END
         ELSE
            BEGIN
               ROLLBACK TRAN TRAN_saveAccountTrans
               RETURN 98
            END
      END

   RETURN 0
END
go

IF OBJECT_ID('dbo.wsp_saveAccountTrans') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_saveAccountTrans >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveAccountTrans >>>'
go

GRANT EXECUTE ON dbo.wsp_saveAccountTrans TO web
go

