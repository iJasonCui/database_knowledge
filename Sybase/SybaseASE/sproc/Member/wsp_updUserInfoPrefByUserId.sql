IF OBJECT_ID('dbo.wsp_updUserInfoPrefByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updUserInfoPrefByUserId
    IF OBJECT_ID('dbo.wsp_updUserInfoPrefByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updUserInfoPrefByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updUserInfoPrefByUserId >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  June 6 2002
**   Description:  Update gender user info by user id
**
** REVISION(S):
**   Author:  Malay Dave
**   Date:  Mar 4 2004
**   Description:  Add new col 'pref_clubll_signup' - for storing clubll signup preference
** 
**   Author:  Valeri Popov
**   Date:  Mar 4 2004
**   Description:  Added new col 'pref_clubll_signup' - for storing clubll signup preference
**
**   Author:  Valeri Popov
**   Date:  July 27 2004
**   Description:  Added new col @localePref - for locale preference
**
**   Author:  Mike Stairs
**   Date:  Feb 8 2005
**   Description:  Added new col searchLanguagesMask
**
**   Author:  Mike Stairs
**   Date:  Nov 2 2005
**   Description:  Added new col pref_community_checkbox, and removed unused columns
**
**   Author:       Andy Tran
**   Date:         Feb 2007
**   Description:  always returns 'N' for mail preference (collect call not accecpted)
**
******************************************************************************/

CREATE PROCEDURE wsp_updUserInfoPrefByUserId
 @preferred_units   CHAR(1)
,@pref_last_on      CHAR(1)
,@mail_dating       CHAR(1)
,@mail_romance      CHAR(1)
,@mail_intimate     CHAR(1)
,@userId            NUMERIC(12,0)
,@pref_clubll_signup CHAR(1)
,@localePref        TINYINT
,@searchLanguageMask INT
,@pref_community_checkbox CHAR(3)
,@mediaReleaseFlag CHAR(1)
AS

DECLARE @dateNow DATETIME
DECLARE @return INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
	
IF @return != 0
BEGIN
  RETURN @return
END

BEGIN TRAN TRAN_updUserInfoPrefByUserId

UPDATE user_info SET
 preferred_units = @preferred_units
,pref_last_on = @pref_last_on
-- ,mail_dating = @mail_dating
-- ,mail_romance = @mail_romance
-- ,mail_intimate = @mail_intimate
,pref_clubll_signup = @pref_clubll_signup
,localePref = @localePref
,searchLanguageMask = @searchLanguageMask
,pref_community_checkbox = @pref_community_checkbox
,dateModified = @dateNow
,mediaReleaseFlag = @mediaReleaseFlag
WHERE user_id = @userId

IF @@error = 0
    BEGIN
        COMMIT TRAN TRAN_updUserInfoPrefByUserId
        RETURN 0
    END
ELSE
    BEGIN
        ROLLBACK TRAN TRAN_updUserInfoPrefByUserId
        RETURN 99
    END 
 
go
GRANT EXECUTE ON dbo.wsp_updUserInfoPrefByUserId TO web
go
IF OBJECT_ID('dbo.wsp_updUserInfoPrefByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updUserInfoPrefByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updUserInfoPrefByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_updUserInfoPrefByUserId','unchained'
go
