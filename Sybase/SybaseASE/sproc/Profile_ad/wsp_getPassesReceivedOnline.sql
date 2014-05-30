IF OBJECT_ID('dbo.wsp_getPassesReceivedOnline') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getPassesReceivedOnline
    IF OBJECT_ID('dbo.wsp_getPassesReceivedOnline') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getPassesReceivedOnline >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getPassesReceivedOnline >>>'
END
go

CREATE PROCEDURE  wsp_getPassesReceivedOnline
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
         userId,
         laston
    FROM Pass,a_profile_dating
    WHERE
         Pass.userId=a_profile_dating.user_id
         AND Pass.targetUserId = @userId
         AND ISNULL(Pass.messageOnHoldStatus,'A') != 'H'
         AND (show_prefs BETWEEN 'A' AND 'Z')
         AND on_line = "Y" 
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
    ORDER BY Pass.dateCreated DESC, userId 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error

END
go
EXEC sp_procxmode 'dbo.wsp_getPassesReceivedOnline','unchained'
go
IF OBJECT_ID('dbo.wsp_getPassesReceivedOnline') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getPassesReceivedOnline >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getPassesReceivedOnline >>>'
go
GRANT EXECUTE ON dbo.wsp_getPassesReceivedOnline TO web
go
