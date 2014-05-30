IF OBJECT_ID('dbo.wsp_newWebTrayAppUsers') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newWebTrayAppUsers
    IF OBJECT_ID('dbo.wsp_newWebTrayAppUsers') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newWebTrayAppUsers >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newWebTrayAppUsers >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Scott U. /Jason C.
**   Date:  Sep 30 2004
**   Description:  insert or update WebTrayAppUsers when lavalife member download webTray
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_newWebTrayAppUsers
    @userId numeric(12,0)
   ,@capacityStatus int OUTPUT
AS
BEGIN

/* @capacityStatus = 1 means reached 500 cap, @capacityStatus = 0 means new customer can download */

DECLARE 
   @return 	        INT
  ,@dateGMT         DATETIME
  ,@WebTrayCapicity INT
  ,@WebTrayRowCount INT
  ,@dateDownload    DATETIME
  ,@rowcountEffect  INT
  
SELECT @WebTrayCapicity = 500
SELECT @capacityStatus = 0

SELECT @WebTrayRowCount = COUNT(*) FROM WebTrayAppUsers WHERE dateDownload IS NOT NULL

EXEC @return = wsp_GetDateGMT @dateGMT OUTPUT
IF @return != 0
BEGIN
   RETURN @return
END

IF @WebTrayRowCount <= @WebTrayCapicity
BEGIN

   SELECT @dateDownload = dateDownload FROM WebTrayAppUsers WHERE userId = @userId
   SELECT @rowcountEffect = @@rowcount --EITHER 1 OR 0 

   IF @rowcountEffect = 1 
   BEGIN
      IF @dateDownload IS NULL  --never download, but login webTray before 
      BEGIN
         BEGIN TRAN TRAN_newWebTrayAppUsers
         UPDATE WebTrayAppUsers SET dateDownload = @dateGMT WHERE userId = @userId
         IF @@error = 0
         BEGIN
            COMMIT TRAN TRAN_newWebTrayAppUsers
            RETURN 0
         END
         ELSE BEGIN
            ROLLBACK TRAN TRAN_newWebTrayAppUsers
            RETURN 99
         END
      END
      ELSE BEGIN --already download and login webTray
         RETURN 0
      END 
   END
   ELSE BEGIN --neither download nor login the webTray

      BEGIN TRAN TRAN_newWebTrayAppUsers

      INSERT WebTrayAppUsers (userId, usageCount, dateCreated, dateDownload)
      VALUES (@userId, 0, @dateGMT, @dateGMT)
   
      IF @@error = 0
      BEGIN
         COMMIT TRAN TRAN_newWebTrayAppUsers
         RETURN 0
      END
      ELSE BEGIN
         ROLLBACK TRAN TRAN_newWebTrayAppUsers
         RETURN 99
      END
   END
END
ELSE BEGIN  --reach the 500 limitation
   SELECT @capacityStatus = 1 
   RETURN 98
END

END

go
IF OBJECT_ID('dbo.wsp_newWebTrayAppUsers') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newWebTrayAppUsers >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newWebTrayAppUsers >>>'
go
EXEC sp_procxmode 'dbo.wsp_newWebTrayAppUsers','unchained'
go
GRANT EXECUTE ON dbo.wsp_newWebTrayAppUsers TO web
go

