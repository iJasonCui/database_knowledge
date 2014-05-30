IF OBJECT_ID('dbo.wsp_getMembNonLocalLists') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMembNonLocalLists
    IF OBJECT_ID('dbo.wsp_getMembNonLocalLists') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMembNonLocalLists >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMembNonLocalLists >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author: Mike Stairs
**   Date:  Feb 4, 2005
**   Description: localized lists searches
**
** REVISION(S):
**   Author: Mike Stairs
**   Date:  Sept 29, 2006
**   Description: priv lists don't use location, so return nothing here
**
******************************************************************************/
CREATE PROCEDURE  wsp_getMembNonLocalLists
@productCode char(1),
@communityCode char(1),
@userId numeric(12,0),
@rowcount int,
@gender char(1),
@lastonCutoff int,
@startingCutoff int,
@type char(2),
@fromLat int,
@fromLong int,
@toLat int,
@toLong int,
@countryId smallint,
@stateId smallint,
@countyId smallint,
@cityId  int,
@createdCutoff int

AS
BEGIN
    SELECT 0 WHERE 0=1
    RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_getMembNonLocalLists TO web
go
IF OBJECT_ID('dbo.wsp_getMembNonLocalLists') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getMembNonLocalLists >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMembNonLocalLists >>>'
go
EXEC sp_procxmode 'dbo.wsp_getMembNonLocalLists','unchained'
go
