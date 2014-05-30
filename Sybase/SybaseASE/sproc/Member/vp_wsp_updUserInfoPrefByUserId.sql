IF OBJECT_ID('dbo.vp_wsp_updUserInfoPrefByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.vp_wsp_updUserInfoPrefByUserId
    IF OBJECT_ID('dbo.vp_wsp_updUserInfoPrefByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.vp_wsp_updUserInfoPrefByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.vp_wsp_updUserInfoPrefByUserId >>>'
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
**   Description:  Added new col 'localePref' - for storing member's navigate locale
**
******************************************************************************/

CREATE PROCEDURE vp_wsp_updUserInfoPrefByUserId
 @preferred_units   CHAR(1)
,@pref_last_on      CHAR(1)
,@pref_email_newmail CHAR(1)
,@pref_email_news   CHAR(1)
,@mail_dating       CHAR(1)
,@mail_romance      CHAR(1)
,@mail_intimate     CHAR(1)
,@msg_dating        CHAR(1)
,@msg_romance       CHAR(1)
,@msg_intimate      CHAR(1)
,@timezone          VARCHAR(10)
,@userId            NUMERIC(12,0)
,@pref_clubll_signup CHAR(1)
,@localePref        TINYINT
AS

BEGIN TRAN TRAN_updUserInfoPrefByUserId

UPDATE user_info SET
 preferred_units = @preferred_units
,pref_last_on = @pref_last_on
,pref_email_newmail = @pref_email_newmail
,pref_email_news = @pref_email_news
,mail_dating = @mail_dating
,mail_romance = @mail_romance
,mail_intimate = @mail_intimate
,msg_dating = @msg_dating
,msg_romance = @msg_romance
,msg_intimate = @msg_intimate
,timezone = @timezone
,pref_clubll_signup = @pref_clubll_signup
,localePref = @localePref
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
GRANT EXECUTE ON dbo.vp_wsp_updUserInfoPrefByUserId TO web
go
IF OBJECT_ID('dbo.vp_wsp_updUserInfoPrefByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.vp_wsp_updUserInfoPrefByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.vp_wsp_updUserInfoPrefByUserId >>>'
go
EXEC sp_procxmode 'dbo.vp_wsp_updUserInfoPrefByUserId','unchained'
go
