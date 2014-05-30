IF OBJECT_ID('dbo.wsp_getProfileQuickGACountry') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getProfileQuickGACountry
    IF OBJECT_ID('dbo.wsp_getProfileQuickGACountry') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getProfileQuickGACountry >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getProfileQuickGACountry >>>'
END
go
   /******************************************************************************
**
** CREATION:
**   Author:  Yahya Kola Ya Hagh   
**   Date:  Sept 23 2004 
**   Description:  retrieves list of members from quick form (by gender, picture, and age)
**   lastonCutoff.
**
**          
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE wsp_getProfileQuickGACountry
@productCode char(1),
@communityCode char(1),
@rowcount int,
@gender char(1),
@lastonCutoff int,
@startingCutoff int,
@fromAge datetime,
@toAge  datetime,
@countryId  int
AS
BEGIN
  SET ROWCOUNT @rowcount
    SELECT 
      user_id as id,
      laston     
    FROM a_profile_intimate
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y')) 
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND gender = @gender
         AND birthdate <= @fromAge
         AND birthdate >= @toAge
         AND countryId = @countryId
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
END
go


GRANT EXECUTE ON dbo.wsp_getProfileQuickGACountry TO web
go

IF OBJECT_ID('dbo.wsp_getProfileQuickGACountry') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getProfileQuickGACountry >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getProfileQuickGACountry >>>'
go

EXEC sp_procxmode 'dbo.wsp_getProfileQuickGACountry','unchained'
go
