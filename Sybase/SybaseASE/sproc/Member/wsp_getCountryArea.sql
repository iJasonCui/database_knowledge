IF OBJECT_ID('dbo.wsp_getCountryArea') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCountryArea
    IF OBJECT_ID('dbo.wsp_getCountryArea') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCountryArea >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCountryArea >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author:  Jason Cui 
**   Date:  May 24 2002  
**   Description:  get CountryArea infomation from table location 
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getCountryArea
AS
BEGIN

SELECT country_area_id, country_area, country
FROM location
WHERE country_area_id is not null

RETURN @@error

END 
 
go
GRANT EXECUTE ON dbo.wsp_getCountryArea TO web
go
IF OBJECT_ID('dbo.wsp_getCountryArea') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getCountryArea >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCountryArea >>>'
go
EXEC sp_procxmode 'dbo.wsp_getCountryArea','unchained'
go
