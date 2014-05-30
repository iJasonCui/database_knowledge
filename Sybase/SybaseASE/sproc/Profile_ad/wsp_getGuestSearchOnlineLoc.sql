IF OBJECT_ID('dbo.wsp_getGuestSearchOnlineLoc') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getGuestSearchOnlineLoc
    IF OBJECT_ID('dbo.wsp_getGuestSearchOnlineLoc') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getGuestSearchOnlineLoc >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getGuestSearchOnlineLoc >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  September 20 2002
**   Description:  Retrieves list of new local members since cutoff
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE wsp_getGuestSearchOnlineLoc
 @productCode CHAR(1)
,@communityCode CHAR(1)
,@rowcount INT
,@gender CHAR(1)
,@lastonCutoff INT
,@startingCutoff INT
,@type CHAR(1)
,@fromLoc NUMERIC(12,0)
,@toLoc NUMERIC(12,0)
AS
BEGIN
	SET ROWCOUNT @rowcount

	SELECT user_id,laston
	FROM a_profile_dating
	WHERE show = 'Y' 
	AND (show_prefs = 'Y' OR show_prefs = 'O')
	AND laston > @startingCutoff
	AND laston < @lastonCutoff
	AND on_line = 'Y'
	AND gender = @gender
	AND location_id >= @fromLoc
	AND location_id <= @toLoc
	ORDER BY laston DESC,user_id
	AT ISOLATION READ UNCOMMITTED

	RETURN @@error
END
 
go
GRANT EXECUTE ON dbo.wsp_getGuestSearchOnlineLoc TO web
go
IF OBJECT_ID('dbo.wsp_getGuestSearchOnlineLoc') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getGuestSearchOnlineLoc >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getGuestSearchOnlineLoc >>>'
go
EXEC sp_procxmode 'dbo.wsp_getGuestSearchOnlineLoc','unchained'
go
