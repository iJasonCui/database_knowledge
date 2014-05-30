IF OBJECT_ID('dbo.wsp_getGuestSearchNewLoc') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getGuestSearchNewLoc
    IF OBJECT_ID('dbo.wsp_getGuestSearchNewLoc') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getGuestSearchNewLoc >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getGuestSearchNewLoc >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  September 20 2002
**   Description:  Retrieves list of new members/pics/backstages since cutoff
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE wsp_getGuestSearchNewLoc
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
	WHERE show='Y' 
	AND (show_prefs = 'Y' OR (show_prefs = 'O' AND on_line = 'Y'))
	AND created_on > @startingCutoff
	AND laston > @startingCutoff
	AND laston < @lastonCutoff
	AND gender = @gender
	AND location_id >= @fromLoc
	AND location_id <= @toLoc
	ORDER BY laston DESC,user_id
	AT ISOLATION READ UNCOMMITTED

	RETURN @@error
END
 
go
GRANT EXECUTE ON dbo.wsp_getGuestSearchNewLoc TO web
go
IF OBJECT_ID('dbo.wsp_getGuestSearchNewLoc') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getGuestSearchNewLoc >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getGuestSearchNewLoc >>>'
go
EXEC sp_procxmode 'dbo.wsp_getGuestSearchNewLoc','unchained'
go
