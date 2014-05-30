IF OBJECT_ID('dbo.wsp_saveSubTransDynaContent') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveSubTransDynaContent
    IF OBJECT_ID('dbo.wsp_saveSubTransDynaContent') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveSubTransDynaContent >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveSubTransDynaContent >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:  Yan Liu 
**   Date:  Janunary 29 2009 
**   Description:  save SubTransactionDynaContent 
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_saveSubTransDynaContent
   @xactionId  INT,
   @sequenceId TINYINT,
   @content    VARCHAR(255)
AS

BEGIN
   DECLARE @return INT
   DECLARE @dateNowGMT DATETIME

   EXEC @return = dbo.wsp_GetDateGMT @dateNowGMT OUTPUT

   IF NOT EXISTS(SELECT 1 FROM SubTransactionDynaContent 
                  WHERE xactionId = @xactionId
                    AND sequenceId = @sequenceId)
      BEGIN
         BEGIN TRAN TRAN_saveSubTransDynaContent
         INSERT INTO SubTransactionDynaContent(xactionId,
                                               sequenceId,
                                               content,  
                                               dateCreated) 
         VALUES(@xactionId,
                @sequenceId,
                @content,
                @dateNowGMT)
 
         IF (@@error = 0)
            BEGIN
               COMMIT TRAN TRAN_saveSubTransDynaContent 
            END
         ELSE
            BEGIN
               ROLLBACK TRAN TRAN_saveSubTransDynaContent          
               RETURN 99
            END
      END

   RETURN 0
END
go

IF OBJECT_ID('dbo.wsp_saveSubTransDynaContent') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_saveSubTransDynaContent >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveSubTransDynaContent >>>'
go

GRANT EXECUTE ON dbo.wsp_saveSubTransDynaContent TO web
go

