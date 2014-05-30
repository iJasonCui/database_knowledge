IF OBJECT_ID('dbo.wssp_getSlideshowByCountryLang') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wssp_getSlideshowByCountryLang
    IF OBJECT_ID('dbo.wssp_getSlideshowByCountryLang') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wssp_getSlideshowByCountryLang >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wssp_getSlideshowByCountryLang >>>'
END
go
/******************************************************************************
**
**   Description: cloned from wsp_getSlideshowByCountryLang
**
******************************************************************************/
 
CREATE PROCEDURE wssp_getSlideshowByCountryLang
@productCode CHAR(1),
@communityCode CHAR(1),
@rowcount INT,
@gender CHAR(1),
@countryId SMALLINT,
@languageMask INT,
@lastonSince INT
AS

BEGIN
  SET ROWCOUNT @rowcount

  IF (@countryId = 0 AND @languageMask <= 0)
  BEGIN
  SELECT ap.myidentity as nickname,
         ap.on_line,
         ap.user_id as userId,
         ap.gender,
         ap.laston
  FROM   a_profile_dating ap, a_mompictures_dating am
  WHERE  am.user_id=ap.user_id
        AND ap.approved='Y'
        AND ap.pict='Y'
        AND ap.myidentity IS NOT NULL
        AND ap.show_prefs='Y'
        AND ap.gender=@gender
        AND ap.laston > @lastonSince 
  ORDER BY ap.laston DESC
  AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE
  IF (@countryId > 0 AND @languageMask > 0)
  BEGIN
  SELECT ap.myidentity as nickname,
         ap.on_line,
         ap.user_id as userId,
         ap.gender,
         ap.laston
  FROM   a_profile_dating ap, a_mompictures_dating am
  WHERE am.user_id=ap.user_id
        AND ISNULL(ap.profileLanguageMask,1) & @languageMask > 0
        AND ap.countryId = @countryId
        AND ap.approved='Y'
        AND ap.pict='Y'
        AND ap.myidentity IS NOT NULL
        AND ap.show_prefs='Y'
        AND ap.gender=@gender
        AND ap.laston > @lastonSince 
  ORDER BY ap.laston DESC
  AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE
  IF @countryId > 0
  BEGIN
  SELECT ap.myidentity as nickname,
         ap.on_line,
         ap.user_id as userId,
         ap.gender,
         ap.laston
  FROM   a_profile_dating ap, a_mompictures_dating am
  WHERE am.user_id=ap.user_id
        AND ap.countryId = @countryId
        AND ap.approved='Y'
        AND ap.pict='Y'
        AND ap.myidentity IS NOT NULL
        AND ap.show_prefs='Y'
        AND ap.gender=@gender
        AND ap.laston > @lastonSince 
  ORDER BY ap.laston DESC
  AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE
  IF @languageMask > 0
  BEGIN
  SELECT ap.myidentity as nickname,
         ap.on_line,
         ap.user_id as userId,
         ap.gender,
         ap.laston
  FROM   a_profile_dating ap, a_mompictures_dating am
  WHERE am.user_id=ap.user_id
        AND ISNULL(ap.profileLanguageMask,1) & @languageMask > 0
        AND ap.approved='Y'
        AND ap.pict='Y'
        AND ap.myidentity IS NOT NULL
        AND ap.show_prefs='Y'
        AND ap.gender=@gender
        AND ap.laston > @lastonSince 
  ORDER BY ap.laston DESC
  AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
END

go
IF OBJECT_ID('dbo.wssp_getSlideshowByCountryLang') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wssp_getSlideshowByCountryLang >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wssp_getSlideshowByCountryLang >>>'
go
EXEC sp_procxmode 'dbo.wssp_getSlideshowByCountryLang','unchained'
go
GRANT EXECUTE ON dbo.wssp_getSlideshowByCountryLang TO web
go
