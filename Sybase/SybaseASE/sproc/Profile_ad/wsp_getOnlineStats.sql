IF OBJECT_ID('dbo.wsp_getOnlineStats') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getOnlineStats
    IF OBJECT_ID('dbo.wsp_getOnlineStats') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getOnlineStats >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getOnlineStats >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author: Slobodan Kandic
**   Date: Nov 1 2002
**   Description: retrieves the number of members, currently online, that
**     a) are on the hotlist of the given user
**     b) that have sent the smile to the given user, and
**     c) that have gotten the smile from the given user
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_getOnlineStats
 @productCode CHAR(1)
,@communityCode CHAR(1)
,@userId NUMERIC(12,0)
,@startingCutoff INT
,@cntHotlist INT OUTPUT
,@cntSmileSent INT OUTPUT
,@cntSmileReceived INT OUTPUT
AS
BEGIN

    SELECT	@cntHotlist = COUNT(*)
    FROM	a_profile_dating p, Hotlist h
    WHERE	h.userId = @userId
    AND		h.targetUserId = p.user_id
    AND		p.on_line='Y'
    AND     p.show_prefs BETWEEN 'A' AND 'Z'
    AND		p.laston > @startingCutoff
	AT ISOLATION READ UNCOMMITTED

	SELECT	@cntSmileSent = COUNT(*)
	FROM	a_profile_dating p, Smile s
	WHERE	s.userId = @userId
	AND		s.targetUserId = p.user_id
	AND		p.on_line='Y'
	AND     p.show_prefs BETWEEN 'A' AND 'Z'
	AND		p.laston > @startingCutoff
	AT ISOLATION READ UNCOMMITTED

	SELECT	@cntSmileReceived = COUNT(*)
	FROM	a_profile_dating p, Smile s
	WHERE	s.targetUserId = @userId
	AND		s.userId = p.user_id
	AND		p.on_line='Y'
	AND     p.show_prefs BETWEEN 'A' AND 'Z'
	AND		p.laston > @startingCutoff
	AND		seen != 'T'
	AT ISOLATION READ UNCOMMITTED

END
 
go
GRANT EXECUTE ON dbo.wsp_getOnlineStats TO web
go
IF OBJECT_ID('dbo.wsp_getOnlineStats') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getOnlineStats >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getOnlineStats >>>'
go
EXEC sp_procxmode 'dbo.wsp_getOnlineStats','unchained'
go
