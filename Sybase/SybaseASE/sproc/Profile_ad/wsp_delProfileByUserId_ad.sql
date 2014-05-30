IF OBJECT_ID('dbo.wsp_delProfileByUserId_ad') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_delProfileByUserId_ad
    IF OBJECT_ID('dbo.wsp_delProfileByUserId_ad') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_delProfileByUserId_ad >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_delProfileByUserId_ad >>>'
END
go
 CREATE PROCEDURE wsp_delProfileByUserId_ad
 @productCode   CHAR(1)
,@communityCode CHAR(1)
,@userId        NUMERIC(12,0)
AS
/******************************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  December 2002  
**   Description:  
**
**          
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/

IF (@productCode = 'a' AND @communityCode='i')
   BEGIN
     EXEC wsp_delProfileByUserId @productCode,@communityCode,@userId
   END
ELSE
IF (@productCode = 'a' AND @communityCode='r')
   BEGIN
     EXEC wsp_delProfileByUserId @productCode,@communityCode,@userId
   END
ELSE
IF (@productCode = 'a' AND @communityCode='d')
   BEGIN
     EXEC wsp_delProfileByUserId @productCode,@communityCode,@userId
   END
ELSE
IF (@productCode = 'm' AND @communityCode='i')
   BEGIN
     EXEC wsp_delProfileByUserId @productCode,@communityCode,@userId
   END
ELSE
IF (@productCode = 'm' AND @communityCode='r')
   BEGIN
     EXEC wsp_delProfileByUserId @productCode,@communityCode,@userId
   END
ELSE
IF (@productCode = 'm' AND @communityCode='d')
   BEGIN
     EXEC wsp_delProfileByUserId @productCode,@communityCode,@userId
   END
ELSE
IF (@productCode = 'w' AND @communityCode='i')
   BEGIN
     EXEC wsp_delProfileByUserId @productCode,@communityCode,@userId
   END
ELSE
IF (@productCode = 'w' AND @communityCode='r')
   BEGIN
     EXEC wsp_delProfileByUserId @productCode,@communityCode,@userId
   END
ELSE
IF (@productCode = 'w' AND @communityCode='d')
   BEGIN
     EXEC wsp_delProfileByUserId @productCode,@communityCode,@userId
   END 
 
go
GRANT EXECUTE ON dbo.wsp_delProfileByUserId_ad TO web
go
IF OBJECT_ID('dbo.wsp_delProfileByUserId_ad') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_delProfileByUserId_ad >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_delProfileByUserId_ad >>>'
go
EXEC sp_procxmode 'dbo.wsp_delProfileByUserId_ad','unchained'
go
