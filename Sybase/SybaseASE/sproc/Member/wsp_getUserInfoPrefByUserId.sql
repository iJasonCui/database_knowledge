IF OBJECT_ID('dbo.wsp_getUserInfoPrefByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserInfoPrefByUserId
    IF OBJECT_ID('dbo.wsp_getUserInfoPrefByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserInfoPrefByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserInfoPrefByUserId >>>'
END
go
/***********************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  June 6 2002
**   Description:  Retrieves prefered infor for a given user id
**
** REVISION(S):
**   Author:  Malay Dave
**   Date:  Mar 4 2004
**   Description:  Add new col 'pref_clubll_signup' - for storing clubll signup preference
**
** REVISION(S):
**   Author:  Travis McCauley
**   Date:  June 1, 2004
**   Description:  get timezone from cityDb timezone. Requires null check on return value in application
**
** REVISION(S):
**   Author:  Valeri Popov
**   Date:  July 27, 2004
**   Description:  added localePref
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: Oct 2005
**   Description: eliminated references to removed columns from user_info
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: June 2006
**   Description: added mediaReleaseFlag
**
**   Author:       Andy Tran
**   Date:         Feb 2007
**   Description:  always returns 'N' for mail preference (collect call not accecpted)
**
*************************************************************************/

CREATE PROCEDURE  wsp_getUserInfoPrefByUserId
@userId NUMERIC(12,0)
AS

BEGIN
	SELECT preferred_units
          ,pref_last_on
          ,'N' --mail_dating
          ,'N' --mail_romance
          ,'N' --mail_intimate
          ,pref_clubll_signup
          ,localePref
          ,searchLanguageMask
          ,ISNULL(pref_community_checkbox,'MMM')
          ,ISNULL(mediaReleaseFlag, 'Y')
	FROM user_info
   left join City on City.cityId = user_info.cityId and user_id = @userId
   
	WHERE user_id = @userId

	RETURN @@error
END 
 

go
EXEC sp_procxmode 'dbo.wsp_getUserInfoPrefByUserId','unchained'
go
IF OBJECT_ID('dbo.wsp_getUserInfoPrefByUserId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserInfoPrefByUserId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserInfoPrefByUserId >>>'
go
GRANT EXECUTE ON dbo.wsp_getUserInfoPrefByUserId TO web
go
