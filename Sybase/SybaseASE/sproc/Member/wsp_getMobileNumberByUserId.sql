IF OBJECT_ID('dbo.wsp_getMobileNumberByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMobileNumberByUserId
    IF OBJECT_ID('dbo.wsp_getMobileNumberByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMobileNumberByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMobileNumberByUserId >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Oct 2006
**   Description: return mobileNumber from WapInfo table 
**
******************************************************************************/

CREATE PROCEDURE  wsp_getMobileNumberByUserId
 @userId NUMERIC(12,0) 

AS
BEGIN
  SELECT mobileNumber FROM WapInfo WHERE userId = @userId
END
 
go
GRANT EXECUTE ON dbo.wsp_getMobileNumberByUserId TO web
go
IF OBJECT_ID('dbo.wsp_getMobileNumberByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getMobileNumberByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMobileNumberByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_getMobileNumberByUserId','unchained'
go
