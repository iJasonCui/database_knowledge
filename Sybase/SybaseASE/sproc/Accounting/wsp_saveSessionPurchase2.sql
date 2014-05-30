USE Accounting
go
IF OBJECT_ID('dbo.wsp_saveSessionPurchase2') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveSessionPurchase2
    IF OBJECT_ID('dbo.wsp_saveSessionPurchase2') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveSessionPurchase2 >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveSessionPurchase2 >>>'
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
**   Author: Mark Jaeckle
**   Date: July 2010
**   Description: added brand
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_saveSessionPurchase2
   @xactionId     NUMERIC(12, 0),
   @sessionAdcode VARCHAR(30),
   @sessionMember CHAR(64),
   @context       CHAR(3),
   @brand       VARCHAR(5)
AS

BEGIN
   DECLARE @return     INT
   DECLARE @dateNowGMT DATETIME

   EXEC @return = dbo.wsp_GetDateGMT @dateNowGMT OUTPUT

   IF (@xactionId > 0) 
      BEGIN
         IF NOT EXISTS(SELECT 1 FROM SessionPurchase WHERE xactionId = @xactionId) 
            BEGIN
               BEGIN TRAN TRAN_saveSessionPurchase2
               INSERT INTO SessionPurchase(xactionId,
                                           sessionAdcode,
                                           sessionMember,
                                           context,
                                           brand,
                                           dateCreated)
               VALUES(@xactionId,
                      @sessionAdcode,
                      @sessionMember, 
                      @context, 
                      @brand,
                      @dateNowGMT)

               IF (@@error = 0)
                  BEGIN
                     COMMIT TRAN TRAN_saveSessionPurchase2
                  END
               ELSE
                  BEGIN
                     ROLLBACK TRAN TRAN_saveSessionPurchase2
                     RETURN 99
                  END
            END
      END

   RETURN 0
END
go
EXEC sp_procxmode 'dbo.wsp_saveSessionPurchase2','unchained'
go
IF OBJECT_ID('dbo.wsp_saveSessionPurchase2') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_saveSessionPurchase2 >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveSessionPurchase2 >>>'
go
GRANT EXECUTE ON dbo.wsp_saveSessionPurchase2 TO web
go
