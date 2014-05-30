IF OBJECT_ID('dbo.wsp_getViewedMeOnline') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getViewedMeOnline
    IF OBJECT_ID('dbo.wsp_getViewedMeOnline') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getViewedMeOnline >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getViewedMeOnline >>>'
END
go
/******************************************************************************
**
**
******************************************************************************/
CREATE PROCEDURE  wsp_getViewedMeOnline
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
@languageMask int
AS
BEGIN

   SET ROWCOUNT @rowcount

    SELECT 
         userId,
         datediff(ss,"Jan 1 00:00:00 1970",v.dateCreated)
    FROM ViewedMe v,a_profile_dating p
    WHERE
         v.userId=p.user_id
         AND v.targetUserId = @userId
         AND on_line='Y'
         AND p.show_prefs in ('Y', 'O')
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND laston > @startingCutoff
         AND v.dateCreated < dateadd(ss,@lastonCutoff,"Jan 1 00:00:00 1970")             
    ORDER BY v.dateCreated DESC, v.userId 
    AT ISOLATION READ UNCOMMITTED
END

go
EXEC sp_procxmode 'dbo.wsp_getViewedMeOnline','unchained'
go
IF OBJECT_ID('dbo.wsp_getViewedMeOnline') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getViewedMeOnline >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getViewedMeOnline >>>'
go
GRANT EXECUTE ON dbo.wsp_getViewedMeOnline TO web
go
