IF OBJECT_ID('dbo.wsp_testProcPromotion_ad') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_testProcPromotion_ad
    IF OBJECT_ID('dbo.wsp_testProcPromotion_ad') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_testProcPromotion_ad >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_testProcPromotion_ad >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  July 2003
**   Description:  
**
**          
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE wsp_testProcPromotion_ad
 @productCode     CHAR(1)
,@communityCode   CHAR(1)
,@type            CHAR(2)
AS
DECLARE @return   INT

IF (@productCode = 'a' AND @communityCode='i')
   BEGIN
     EXEC @return = wsp_testProcPromotion @productCode,@communityCode,@type
   END
ELSE
IF (@productCode = 'a' AND @communityCode='r')
   BEGIN
     EXEC @return = wsp_testProcPromotion @productCode,@communityCode,@type
   END
ELSE
IF (@productCode = 'a' AND @communityCode='d')
   BEGIN
     EXEC @return = wsp_testProcPromotion @productCode,@communityCode,@type
   END
ELSE
IF (@productCode = 'm' AND @communityCode='i')
   BEGIN
     EXEC @return = wsp_testProcPromotion @productCode,@communityCode,@type
   END
ELSE
IF (@productCode = 'm' AND @communityCode='r')
   BEGIN
     EXEC @return = wsp_testProcPromotion @productCode,@communityCode,@type
   END
ELSE
IF (@productCode = 'm' AND @communityCode='d')
   BEGIN
     EXEC @return = wsp_testProcPromotion @productCode,@communityCode,@type
   END
ELSE
IF (@productCode = 'w' AND @communityCode='i')
   BEGIN
     EXEC @return = wsp_testProcPromotion @productCode,@communityCode,@type
   END
ELSE
IF (@productCode = 'w' AND @communityCode='r')
   BEGIN
     EXEC @return = wsp_testProcPromotion @productCode,@communityCode,@type
   END
ELSE
IF (@productCode = 'w' AND @communityCode='d')
   BEGIN
     EXEC @return = wsp_testProcPromotion @productCode,@communityCode,@type
   END 
RETURN @return
 
 
go
GRANT EXECUTE ON dbo.wsp_testProcPromotion_ad TO web
go
IF OBJECT_ID('dbo.wsp_testProcPromotion_ad') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_testProcPromotion_ad >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_testProcPromotion_ad >>>'
go
EXEC sp_procxmode 'dbo.wsp_testProcPromotion_ad','unchained'
go
