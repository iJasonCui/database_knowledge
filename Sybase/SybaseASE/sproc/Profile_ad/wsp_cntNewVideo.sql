IF OBJECT_ID('dbo.wsp_cntNewVideo') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntNewVideo
    IF OBJECT_ID('dbo.wsp_cntNewVideo') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntNewVideo >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntNewVideo >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author: Anna Deigin
**   Date: January 2004
**   Description: retrieves the number of videos (profile/backstage), submitted 
**   by the members of the given gender after the given cutoff date.
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: Feb 2005
**   Description: use languageMask
**
******************************************************************************/

CREATE PROCEDURE  wsp_cntNewVideo
@productCode CHAR(1),
@communityCode CHAR(1),
@userId NUMERIC(12,0),
@gender CHAR(1),
@languageMask INT,
@cutoff INT
AS
BEGIN

    SELECT      COUNT(distinct userId)
        FROM    a_profile_dating p, ProfileMedia m
        WHERE	p.user_id=m.userId	
        AND     show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y')) 
        AND NOT EXISTS
         (
              SELECT
                   targetUserId
              FROM Blocklist
              WHERE
                 userId=@userId
                 AND targetUserId=p.user_id
         )
	AND     gender = @gender
        AND     ISNULL(profileLanguageMask,1) & @languageMask > 0   
	AND	laston > @cutoff
        AND     m.dateCreated >= dateadd(ss,@cutoff,"Jan 1 00:00 1970")
        AND     m.mediaType='v'
	AND	(m.profileFlag='Y' OR m.backstageFlag='Y')
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error

END
go
GRANT EXECUTE ON dbo.wsp_cntNewVideo TO web 
go
IF OBJECT_ID('dbo.wsp_cntNewVideo') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_cntNewVideo >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntNewVideo >>>'
go
