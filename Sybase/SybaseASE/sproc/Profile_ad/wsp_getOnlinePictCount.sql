IF OBJECT_ID('dbo.wsp_getOnlinePictCount') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getOnlinePictCount
    IF OBJECT_ID('dbo.wsp_getOnlinePictCount') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getOnlinePictCount >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getOnlinePictCount >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Date:  May 4, 2010
**   Description: localized online picture count to match the result of both 
**   wsp_getOnlinePictCount  and wsp_getMembNonLocalOnline with "P" type (picture) .
**
**
******************************************************************************/
CREATE PROCEDURE  wsp_getOnlinePictCount
@gender char(1),
@startingCutoff int,
@languageMask int
AS
BEGIN
    SELECT count(*)
    FROM a_profile_dating (index ndx_search_pict)
    WHERE
         show='Y' AND (show_prefs='Y' OR show_prefs='O') 
         AND laston > @startingCutoff
         AND gender = @gender
         AND on_line='Y'
         AND pict='Y'
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
END
go
EXEC sp_procxmode 'dbo.wsp_getOnlinePictCount','unchained'
go
IF OBJECT_ID('dbo.wsp_getOnlinePictCount') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getOnlinePictCount >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getOnlinePictCount >>>'
go
GRANT EXECUTE ON dbo.wsp_getOnlinePictCount TO web
go
