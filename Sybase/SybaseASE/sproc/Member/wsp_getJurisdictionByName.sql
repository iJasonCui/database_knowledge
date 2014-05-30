IF OBJECT_ID('dbo.wsp_getJurisdictionByName') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.wsp_getJurisdictionByName
   IF OBJECT_ID('dbo.wsp_getJurisdictionByName') IS NOT NULL
      PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getJurisdictionByName >>>'
   ELSE
      PRINT '<<< DROPPED PROCEDURE dbo.wsp_getJurisdictionByName >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author: Yan L 
**   Date:  Oct 24 2008
**   Description: Retrieves jurisdiction info by countryId, jurisdictionName 
**
** REVISION(S):
**   Author: 
**   Date:  
**   Description: 
**
******************************************************************************/

CREATE PROCEDURE wsp_getJurisdictionByName
   @countryId        SMALLINT,
   @jurisdictionName VARCHAR(100)
AS

BEGIN
   SELECT @jurisdictionName = LTRIM(RTRIM(UPPER(@jurisdictionName)))

   SET ROWCOUNT 1
   SELECT jurisdictionId AS regionId, 
          jurisdictionName AS regionLabel
     FROM Jurisdiction 
    WHERE countryId = @countryId
      AND UPPER(jurisdictionName) = @jurisdictionName 
      AND jurisdictionId = parentId 

   RETURN @@error
END 
go

GRANT EXECUTE ON dbo.wsp_getJurisdictionByName TO web
go

IF OBJECT_ID('dbo.wsp_getJurisdictionByName') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getJurisdictionByName >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getJurisdictionByName >>>'
go

EXEC sp_procxmode 'dbo.wsp_getJurisdictionByName','unchained'
go
