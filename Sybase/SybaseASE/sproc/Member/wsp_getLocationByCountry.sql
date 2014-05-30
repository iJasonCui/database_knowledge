IF OBJECT_ID('dbo.wsp_getLocationByCountry') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getLocationByCountry
    IF OBJECT_ID('dbo.wsp_getLocationByCountry') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getLocationByCountry >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getLocationByCountry >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author: Jeff Yang/Jack Veiga
**   Date:  September 19 2002
**   Description: Retrieves geographical information by country 
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_getLocationByCountry
@country VARCHAR(24)
AS

BEGIN

    SELECT country_id
    ,region_id
    ,country_area_id
    FROM location 
    WHERE country = @country

	RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_getLocationByCountry TO web
go
IF OBJECT_ID('dbo.wsp_getLocationByCountry') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getLocationByCountry >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getLocationByCountry >>>'
go
EXEC sp_procxmode 'dbo.wsp_getLocationByCountry','unchained'
go
