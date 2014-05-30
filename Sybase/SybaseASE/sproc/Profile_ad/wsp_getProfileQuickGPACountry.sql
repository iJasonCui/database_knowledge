IF OBJECT_ID('dbo.wsp_getProfileQuickGPACountry') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getProfileQuickGPACountry
    IF OBJECT_ID('dbo.wsp_getProfileQuickGPACountry') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getProfileQuickGPACountry >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getProfileQuickGPACountry >>>'
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
CREATE PROCEDURE wsp_getProfileQuickGPACountry
@productCode char(1),
@communityCode char(1),
@rowcount int,
@gender char(1),
@lastonCutoff int,
@startingCutoff int,
@pictureFlag char(1),
@fromAge datetime,
@toAge  datetime,
@countryId  int
AS
BEGIN
  SET ROWCOUNT @rowcount
    SELECT 
      user_id as id,
      laston     
    FROM a_profile_dating
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y')) 
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND gender = @gender
         AND pict=@pictureFlag
         AND birthdate <= @fromAge
         AND birthdate >= @toAge
         AND countryId = @countryId
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
END
go


GRANT EXECUTE ON dbo.wsp_getProfileQuickGPACountry TO web
go

IF OBJECT_ID('dbo.wsp_getProfileQuickGPACountry') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getProfileQuickGPACountry >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getProfileQuickGPACountry >>>'
go

EXEC sp_procxmode 'dbo.wsp_getProfileQuickGPACountry','unchained'
go
