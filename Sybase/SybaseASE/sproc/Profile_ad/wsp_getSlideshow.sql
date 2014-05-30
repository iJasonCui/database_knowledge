IF OBJECT_ID('dbo.wsp_getSlideshow') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getSlideshow
    IF OBJECT_ID('dbo.wsp_getSlideshow') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getSlideshow >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getSlideshow >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  July 4 2002
**   Description:  retrieves slideshow items (brand: r - regular, f - fifty+,
**   i  - Australia Introline)
**
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
 
CREATE PROCEDURE wsp_getSlideshow
@productCode CHAR(1),
@communityCode CHAR(1),
@rowcount INT,
@gender CHAR(1),
@brand CHAR(1),
@lastonCutoff INT
AS

BEGIN
  SET ROWCOUNT @rowcount

  IF (@brand = 'r')
  BEGIN
  SELECT myidentity,
        a_profile_dating.on_line,
        a_profile_dating.user_id
  FROM  a_profile_dating, a_mompictures_dating
  WHERE a_mompictures_dating.user_id=a_profile_dating.user_id
        AND a_mompictures_dating.r_brand='Y'
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
  IF (@brand = 'f')
  BEGIN
  SELECT myidentity,
        a_profile_dating.on_line,
        a_profile_dating.user_id
  FROM  a_profile_dating, a_mompictures_dating
  WHERE a_mompictures_dating.user_id=a_profile_dating.user_id
        AND a_mompictures_dating.f_brand='Y'
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
  IF (@brand = 'i')
  BEGIN
  SELECT myidentity,
        a_profile_dating.on_line,
        a_profile_dating.user_id
  FROM  a_profile_dating, a_mompictures_dating
  WHERE a_mompictures_dating.user_id=a_profile_dating.user_id
        AND a_mompictures_dating.i_brand='Y'
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
GRANT EXECUTE ON dbo.wsp_getSlideshow TO web
go
IF OBJECT_ID('dbo.wsp_getSlideshow') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getSlideshow >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getSlideshow >>>'
go
EXEC sp_procxmode 'dbo.wsp_getSlideshow','unchained'
go
