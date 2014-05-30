IF OBJECT_ID('dbo.wsp_saveAdminAccountTrans') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveAdminAccountTrans
    IF OBJECT_ID('dbo.wsp_saveAdminAccountTrans') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveAdminAccountTrans >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveAdminAccountTrans >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:  Yan Liu 
**   Date:  April 11 2008 
**   Description:  save purchase 
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_saveAdminAccountTrans
   @xactionId   NUMERIC(12, 0),
   @adminUserId INT,
   @userId      NUMERIC(12, 0)
AS

BEGIN
   DECLARE @return     INT
   DECLARE @dateNowGMT DATETIME

   EXEC @return = dbo.wsp_GetDateGMT @dateNowGMT OUTPUT

   IF NOT EXISTS(SELECT 1 FROM AdminAccountTransaction 
                  WHERE xactionId = @xactionId) 

   BEGIN
      BEGIN TRAN TRAN_saveAdminAccountTrans
      INSERT INTO AdminAccountTransaction(xactionId,
                                          adminUserId,        
                                          userId,
                                          dateCreated)
      VALUES(@xactionId,
             @adminUserId,
             @userId,
             @dateNowGMT)

      IF (@@error != 0)
         BEGIN
            ROLLBACK TRAN TRAN_saveAdminAccountTrans 
            RETURN 99
         END
      ELSE 
         BEGIN
            COMMIT TRAN TRAN_saveAdminAccountTrans
         END
   END

   RETURN 0
END
go

IF OBJECT_ID('dbo.wsp_saveAdminAccountTrans') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_saveAdminAccountTrans >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveAdminAccountTrans >>>'
go

GRANT EXECUTE ON dbo.wsp_saveAdminAccountTrans TO web
go

