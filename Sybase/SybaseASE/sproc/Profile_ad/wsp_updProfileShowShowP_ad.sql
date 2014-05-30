IF OBJECT_ID('dbo.wsp_updProfileShowShowP_ad') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updProfileShowShowP_ad
    IF OBJECT_ID('dbo.wsp_updProfileShowShowP_ad') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updProfileShowShowP_ad >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updProfileShowShowP_ad >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  February 2003  
**   Description:  
**
**          
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE wsp_updProfileShowShowP_ad
 @productCode CHAR(1)
,@communityCode CHAR(1)
,@userId NUMERIC(12,0)
,@show CHAR(1)
,@show_prefs CHAR(1)
AS
DECLARE @return   INT

IF (@productCode = 'a' AND @communityCode='i')
   BEGIN
     EXEC @return = wsp_updProfileShowShowP @productCode,@communityCode,@userId,@show,@show_prefs
   END
ELSE
IF (@productCode = 'a' AND @communityCode='r')
   BEGIN
     EXEC @return = wsp_updProfileShowShowP @productCode,@communityCode,@userId,@show,@show_prefs
   END
ELSE
IF (@productCode = 'a' AND @communityCode='d')
   BEGIN
     EXEC @return = wsp_updProfileShowShowP @productCode,@communityCode,@userId,@show,@show_prefs
   END
ELSE
IF (@productCode = 'm' AND @communityCode='i')
   BEGIN
     EXEC @return = wsp_updProfileShowShowP @productCode,@communityCode,@userId,@show,@show_prefs
   END
ELSE
IF (@productCode = 'm' AND @communityCode='r')
   BEGIN
     EXEC @return = wsp_updProfileShowShowP @productCode,@communityCode,@userId,@show,@show_prefs
   END
ELSE
IF (@productCode = 'm' AND @communityCode='d')
   BEGIN
     EXEC @return = wsp_updProfileShowShowP @productCode,@communityCode,@userId,@show,@show_prefs
   END
ELSE
IF (@productCode = 'w' AND @communityCode='i')
   BEGIN
     EXEC @return = wsp_updProfileShowShowP @productCode,@communityCode,@userId,@show,@show_prefs
   END
ELSE
IF (@productCode = 'w' AND @communityCode='r')
   BEGIN
     EXEC @return = wsp_updProfileShowShowP @productCode,@communityCode,@userId,@show,@show_prefs
   END
ELSE
IF (@productCode = 'w' AND @communityCode='d')
   BEGIN
     EXEC @return = wsp_updProfileShowShowP @productCode,@communityCode,@userId,@show,@show_prefs
   END 
RETURN @return
 
go
GRANT EXECUTE ON dbo.wsp_updProfileShowShowP_ad TO web
go
IF OBJECT_ID('dbo.wsp_updProfileShowShowP_ad') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updProfileShowShowP_ad >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updProfileShowShowP_ad >>>'
go
EXEC sp_procxmode 'dbo.wsp_updProfileShowShowP_ad','unchained'
go
