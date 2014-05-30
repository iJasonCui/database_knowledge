IF OBJECT_ID('dbo.wsp_getPremium') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.wsp_getPremium
   IF OBJECT_ID('dbo.wsp_getPremium') IS NOT NULL
      PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getPremium >>>'
   ELSE
      PRINT '<<< DROPPED PROCEDURE dbo.wsp_getPremium >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:  Yan Liu 
**   Date:  April 18, 2008
**   Description:  retrieves all premium package info 
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getPremium
AS

BEGIN  
   SELECT premiumId,
          premiumDesc, 
          contentId, 
          dateCreated,
          dateExpiry,
          features 
     FROM Premium 

   RETURN @@error
END
go

IF OBJECT_ID('dbo.wsp_getPremium') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getPremium >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getPremium >>>'
go

GRANT EXECUTE ON dbo.wsp_getPremium TO web
go
