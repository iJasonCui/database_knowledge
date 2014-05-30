IF OBJECT_ID('dbo.wsp_getMembViewedMeNew') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMembViewedMeNew
    IF OBJECT_ID('dbo.wsp_getMembViewedMeNew') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMembViewedMeNew >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMembViewedMeNew >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:       Eugene Huang
**   Date:         June 24, 2010
**   Description:  list search. new style stored procedure which does only one
**                 query. note the parameters are not all used, they are retained
**                 to make the API consistent with existing -- this might be fixed
**                 in the future.
**
** REVISION(S):
**   Author:       
**   Date:         
**   Description:  
**
******************************************************************************/
CREATE PROCEDURE  wsp_getMembViewedMeNew
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
SET ROWCOUNT @rowcount

    --SET FORCEPLAN ON
    SELECT v.userId, datediff(ss, 'Jan 1 00:00:00 1970', v.dateCreated)
      FROM ViewedMe v , a_profile_dating p
--      FROM a_profile_dating p, ViewedMe v ( INDEX XAK1ViewedMe )
     WHERE v.targetUserId = @userId
       AND v.userId = p.user_id
       AND v.dateCreated < dateadd(ss, @lastonCutoff, 'Jan 1 00:00:00 1970')
       AND p.show_prefs in ('Y', 'O')
       AND v.seen IN ('N', 'O')
       AND v.dateCreated > dateadd(ss, @startingCutoff, 'Jan 1 00:00:00 1970')
       -- after Sept 1, 2010, the preceding clause may be changed to
       -- AND (show_prefs BETWEEN 'A' AND 'Z')
       -- this allows some time for the incorrect data to expire
       -- in the past, hidden users were erroneously recording ViewedMe records - we don't want to show them
--       AND v.userId NOT IN (SELECT targetUserId FROM Blocklist WHERE userId = @userId)
    ORDER BY v.dateCreated DESC, v.userId 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error

END
go
EXEC sp_procxmode 'dbo.wsp_getMembViewedMeNew','unchained'
go
IF OBJECT_ID('dbo.wsp_getMembViewedMeNew') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getMembViewedMeNew >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMembViewedMeNew >>>'
go
GRANT EXECUTE ON dbo.wsp_getMembViewedMeNew TO web
go
