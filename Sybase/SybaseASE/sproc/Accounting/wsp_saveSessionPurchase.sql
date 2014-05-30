IF OBJECT_ID('dbo.wsp_saveSessionPurchase') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveSessionPurchase
    IF OBJECT_ID('dbo.wsp_saveSessionPurchase') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveSessionPurchase >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveSessionPurchase >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:  Yan Liu 
**   Date:  September 9 2008 
**   Description:  save SessionPurchase 
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_saveSessionPurchase
   @xactionId     NUMERIC(12, 0),
   @sessionAdcode VARCHAR(30),
   @sessionMember CHAR(64),
   @context       CHAR(3)
AS

BEGIN
   DECLARE @return     INT
   DECLARE @dateNowGMT DATETIME

   EXEC @return = dbo.wsp_GetDateGMT @dateNowGMT OUTPUT

   IF (@xactionId > 0) 
      BEGIN
         IF NOT EXISTS(SELECT 1 FROM SessionPurchase WHERE xactionId = @xactionId) 
            BEGIN
               BEGIN TRAN TRAN_saveSessionPurchase
               INSERT INTO SessionPurchase(xactionId,
                                           sessionAdcode,
                                           sessionMember,
                                           context,
                                           dateCreated)
               VALUES(@xactionId,
                      @sessionAdcode,
                      @sessionMember, 
                      @context, 
                      @dateNowGMT)

               IF (@@error = 0)
                  BEGIN
                     COMMIT TRAN TRAN_saveSessionPurchase
                  END
               ELSE
                  BEGIN
                     ROLLBACK TRAN TRAN_saveSessionPurchase
                     RETURN 99
                  END
            END
      END

   RETURN 0
END
go

IF OBJECT_ID('dbo.wsp_saveSessionPurchase') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_saveSessionPurchase >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveSessionPurchase >>>'
go

GRANT EXECUTE ON dbo.wsp_saveSessionPurchase TO web
go

