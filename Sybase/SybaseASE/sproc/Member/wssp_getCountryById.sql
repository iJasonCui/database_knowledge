IF OBJECT_ID('dbo.wssp_getCountryByIsoCode') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wssp_getCountryById
    IF OBJECT_ID('dbo.wssp_getCountryById') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wssp_getCountryById >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wssp_getCountryById >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author: F Schonberger
**   Date:  Oct, 2010
**   Description: Retrieves countryId by id.
**
******************************************************************************/
CREATE PROCEDURE  wssp_getCountryById
 @countryId INT
AS

BEGIN
    SELECT countryId,
           countryLabel AS countryName,
           countryCodeIso
      FROM Country c
     WHERE countryId = @countryId
    
    RETURN @@error
END
go
EXEC sp_procxmode 'dbo.wssp_getCountryById','unchained'
go
IF OBJECT_ID('dbo.wssp_getCountryById') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wssp_getCountryById >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wssp_getCountryById >>>'
go
GRANT EXECUTE ON dbo.wssp_getCountryById TO web
go
