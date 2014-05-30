IF OBJECT_ID('dbo.wsp_getMembNonLocalListsVIP') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMembNonLocalListsVIP
    IF OBJECT_ID('dbo.wsp_getMembNonLocalListsVIP') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMembNonLocalListsVIP >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMembNonLocalListsVIP >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author: Yadira Genoves X
**   Date:  July 2009
**   Description: Get VIP people
**
******************************************************************************/
CREATE PROCEDURE  wsp_getMembNonLocalListsVIP
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
EXEC sp_procxmode 'dbo.wsp_getMembNonLocalListsVIP','unchained'
go
IF OBJECT_ID('dbo.wsp_getMembNonLocalListsVIP') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getMembNonLocalListsVIP >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMembNonLocalListsVIP >>>'
go
GRANT EXECUTE ON dbo.wsp_getMembNonLocalListsVIP TO web
go
