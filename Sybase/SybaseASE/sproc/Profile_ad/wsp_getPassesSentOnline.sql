IF OBJECT_ID('dbo.wsp_getPassesSentOnline') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getPassesSentOnline
    IF OBJECT_ID('dbo.wsp_getPassesSentOnline') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getPassesSentOnline >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getPassesSentOnline >>>'
END
go

CREATE PROCEDURE  wsp_getPassesSentOnline
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

    SELECT 
         targetUserId,
         laston
    FROM Pass,a_profile_dating
    WHERE
         Pass.targetUserId=a_profile_dating.user_id
         AND Pass.userId = @userId
         AND (show_prefs BETWEEN 'A' AND 'Z')
         AND seen IN ('N', 'O')
         AND on_line="Y"
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
    ORDER BY Pass.dateCreated DESC, targetUserId 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error

END
go
EXEC sp_procxmode 'dbo.wsp_getPassesSentOnline','unchained'
go
IF OBJECT_ID('dbo.wsp_getPassesSentOnline') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getPassesSentOnline >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getPassesSentOnline >>>'
go
GRANT EXECUTE ON dbo.wsp_getPassesSentOnline TO web
go
