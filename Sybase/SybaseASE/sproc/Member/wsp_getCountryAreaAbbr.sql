IF OBJECT_ID('dbo.wsp_getCountryAreaAbbr') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCountryAreaAbbr
    IF OBJECT_ID('dbo.wsp_getCountryAreaAbbr') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCountryAreaAbbr >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCountryAreaAbbr >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author:  Jason Cui 
**   Date:  May 24 2002  
**   Description:  retrieve country area abbr
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getCountryAreaAbbr
@country_area varchar(32)
AS
BEGIN

SELECT country_area_abbr
FROM location
WHERE country_area = @country_area
      AND country = 'USA'

RETURN @@error
        
END 
 
go
GRANT EXECUTE ON dbo.wsp_getCountryAreaAbbr TO web
go
IF OBJECT_ID('dbo.wsp_getCountryAreaAbbr') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getCountryAreaAbbr >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCountryAreaAbbr >>>'
go
EXEC sp_procxmode 'dbo.wsp_getCountryAreaAbbr','unchained'
go
