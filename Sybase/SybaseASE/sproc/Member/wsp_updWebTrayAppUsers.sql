IF OBJECT_ID('dbo.wsp_updWebTrayAppUsers') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updWebTrayAppUsers
    IF OBJECT_ID('dbo.wsp_updWebTrayAppUsers') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updWebTrayAppUsers >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updWebTrayAppUsers >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Jason C.
**   Date:  Oct 6 2004
**   Description:  update WebTrayAppUsers when lavalife member login webTray
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_updWebTrayAppUsers
    @userId numeric(12,0)
AS
BEGIN

DECLARE 
   @return 	        INT
  ,@dateGMT         DATETIME
  ,@rowcountEffect  INT
  
EXEC @return = wsp_GetDateGMT @dateGMT OUTPUT
IF @return != 0
BEGIN
   RETURN @return
END

IF EXISTS (SELECT 1 FROM WebTrayAppUsers WHERE userId = @userId)
BEGIN
   BEGIN TRAN TRAN_updWebTrayAppUsers
   UPDATE WebTrayAppUsers 
   SET usageCount = usageCount + 1, 
       dateLastLogin = @dateGMT
   WHERE userId = @userId

   IF @@error = 0
   BEGIN
      COMMIT TRAN TRAN_updWebTrayAppUsers
      RETURN 0
   END
   ELSE BEGIN
      ROLLBACK TRAN TRAN_updWebTrayAppUsers
      RETURN 99
   END
END
ELSE BEGIN --have not download, but login webTray through other member's downloaded tray
         
   BEGIN TRAN TRAN_updWebTrayAppUsers

   INSERT WebTrayAppUsers (userId, usageCount, dateCreated, dateLastLogin)
   VALUES (@userId, 1, @dateGMT, @dateGMT)
   
   IF @@error = 0
   BEGIN
      COMMIT TRAN TRAN_updWebTrayAppUsers
      RETURN 0
   END
   ELSE BEGIN
      ROLLBACK TRAN TRAN_updWebTrayAppUsers
      RETURN 99
   END
END


END

go
IF OBJECT_ID('dbo.wsp_updWebTrayAppUsers') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updWebTrayAppUsers >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updWebTrayAppUsers >>>'
go
EXEC sp_procxmode 'dbo.wsp_updWebTrayAppUsers','unchained'
go
GRANT EXECUTE ON dbo.wsp_updWebTrayAppUsers TO web
go

