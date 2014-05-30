IF OBJECT_ID('dbo.wsp_getSlideshowByCountryLang') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getSlideshowByCountryLang
    IF OBJECT_ID('dbo.wsp_getSlideshowByCountryLang') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getSlideshowByCountryLang >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getSlideshowByCountryLang >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  July 4 2002
**   Description:  retrieves slideshow items by country and/or language
**
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
 
CREATE PROCEDURE wsp_getSlideshowByCountryLang
@productCode CHAR(1),
@communityCode CHAR(1),
@rowcount INT,
@gender CHAR(1),
@countryId SMALLINT,
@languageMask INT,
@lastonCutoff INT
AS

BEGIN
  SET ROWCOUNT @rowcount

  IF (@countryId = 0 AND @languageMask <= 0)
  BEGIN
  SELECT myidentity,
        a_profile_dating.on_line,
        a_profile_dating.user_id,
        a_profile_dating.countryId,
        a_profile_dating.profileLanguageMask
  FROM  a_profile_dating, a_mompictures_dating
  WHERE a_mompictures_dating.user_id=a_profile_dating.user_id
        AND a_profile_dating.approved='Y'
        AND a_profile_dating.pict='Y'
        AND a_profile_dating.myidentity IS NOT NULL
        AND a_profile_dating.show_prefs='Y'
        AND a_profile_dating.gender=@gender
        AND laston > @lastonCutoff 
  ORDER BY laston DESC
  AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE
  IF (@countryId > 0 AND @languageMask > 0)
  BEGIN
  SELECT myidentity,
        a_profile_dating.on_line,
        a_profile_dating.user_id,
        a_profile_dating.countryId,
        a_profile_dating.profileLanguageMask
  FROM  a_profile_dating, a_mompictures_dating
  WHERE a_mompictures_dating.user_id=a_profile_dating.user_id
        AND ISNULL(profileLanguageMask,1) & @languageMask > 0
        AND countryId = @countryId
        AND a_profile_dating.approved='Y'
        AND a_profile_dating.pict='Y'
        AND a_profile_dating.myidentity IS NOT NULL
        AND a_profile_dating.show_prefs='Y'
        AND a_profile_dating.gender=@gender
        AND laston > @lastonCutoff 
  ORDER BY laston DESC
  AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE
  IF @countryId > 0
  BEGIN
  SELECT myidentity,
        a_profile_dating.on_line,
        a_profile_dating.user_id,
        a_profile_dating.countryId,
        a_profile_dating.profileLanguageMask
  FROM  a_profile_dating, a_mompictures_dating
  WHERE a_mompictures_dating.user_id=a_profile_dating.user_id
        AND countryId = @countryId
        AND a_profile_dating.approved='Y'
        AND a_profile_dating.pict='Y'
        AND a_profile_dating.myidentity IS NOT NULL
        AND a_profile_dating.show_prefs='Y'
        AND a_profile_dating.gender=@gender
        AND laston > @lastonCutoff 
  ORDER BY laston DESC
  AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE
  IF @languageMask > 0
  BEGIN
  SELECT myidentity,
        a_profile_dating.on_line,
        a_profile_dating.user_id,
        a_profile_dating.countryId,
        a_profile_dating.profileLanguageMask
  FROM  a_profile_dating, a_mompictures_dating
  WHERE a_mompictures_dating.user_id=a_profile_dating.user_id
        AND ISNULL(profileLanguageMask,1) & @languageMask > 0
        AND a_profile_dating.approved='Y'
        AND a_profile_dating.pict='Y'
        AND a_profile_dating.myidentity IS NOT NULL
        AND a_profile_dating.show_prefs='Y'
        AND a_profile_dating.gender=@gender
        AND laston > @lastonCutoff 
  ORDER BY laston DESC
  AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
END
 
 
go
GRANT EXECUTE ON dbo.wsp_getSlideshowByCountryLang TO web
go
IF OBJECT_ID('dbo.wsp_getSlideshowByCountryLang') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getSlideshowByCountryLang >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getSlideshowByCountryLang >>>'
go
EXEC sp_procxmode 'dbo.wsp_getSlideshowByCountryLang','unchained'
go
