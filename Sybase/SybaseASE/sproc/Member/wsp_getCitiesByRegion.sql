IF OBJECT_ID('dbo.wsp_getCitiesByRegion') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCitiesByRegion
    IF OBJECT_ID('dbo.wsp_getCitiesByRegion') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCitiesByRegion >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCitiesByRegion >>>'
END
go
  /***********************************************************************
**
** CREATION:
**   Author:  Mirjana Cetojevic
**   Date:  February 23, 2004
**   Description:  Returns city list with IVR phone numbers for given region
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*************************************************************************/

CREATE PROCEDURE  wsp_getCitiesByRegion
@region VARCHAR(16)
AS

BEGIN

SELECT city, phone, totalusers
FROM byphone
WHERE region = @region
ORDER BY cityorder ASC

RETURN @@error

END

go
GRANT EXECUTE ON dbo.wsp_getCitiesByRegion TO web
go
IF OBJECT_ID('dbo.wsp_getCitiesByRegion') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getCitiesByRegion >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCitiesByRegion >>>'
go
EXEC sp_procxmode 'dbo.wsp_getCitiesByRegion','unchained'
go
