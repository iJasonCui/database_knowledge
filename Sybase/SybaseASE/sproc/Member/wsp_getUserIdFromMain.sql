IF OBJECT_ID('dbo.wsp_getUserIdFromMain') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserIdFromMain
    IF OBJECT_ID('dbo.wsp_getUserIdFromMain') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserIdFromMain >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserIdFromMain >>>'
END
go 

/***********************************************************************
**
** CREATION:
**   Author: Generator 
**   Date: @TIMESTAMP@ 
**   Description: getUserIdFromMain 
**
*************************************************************************/
CREATE PROCEDURE  wsp_getUserIdFromMain
    @password varchar(8),
    @email varchar(100)
AS

BEGIN

   BEGIN TRAN TRAN_getUserIdFromMain


    
   SELECT @email = UPPER(@email) 
   SELECT @password = UPPER(@password) 
   DECLARE @llUserId NUMERIC(10,0)  
   DECLARE @userId NUMERIC(10,0)  
   SELECT @llUserId = user_id
   FROM user_info
   WHERE email=@email AND
         password=@password
  
   EXEC wsp_UserId @userId OUTPUT


   SELECT @userId as userId, @llUserId as llUserId     


   IF @@error = 0
   BEGIN
      COMMIT TRAN TRAN_getUserIdFromMain
   END
   ELSE BEGIN
      ROLLBACK TRAN TRAN_getUserIdFromMain
   END

END
go

GRANT EXECUTE ON dbo.wsp_getUserIdFromMain TO web
go

IF OBJECT_ID('dbo.wsp_getUserIdFromMain') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserIdFromMain >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserIdFromMain >>>'
go

EXEC sp_procxmode 'dbo.wsp_getUserIdFromMain','unchained'
go

