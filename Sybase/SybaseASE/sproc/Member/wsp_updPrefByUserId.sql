IF OBJECT_ID('dbo.wsp_updPrefByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updPrefByUserId
    IF OBJECT_ID('dbo.wsp_updPrefByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updPrefByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updPrefByUserId >>>'
END
go

CREATE PROCEDURE wsp_updPrefByUserId
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
AS

DECLARE @dateNow DATETIME
DECLARE @return INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
	
IF @return != 0
BEGIN
  RETURN @return
END

BEGIN TRAN TRAN_updPrefByUserId

UPDATE user_info SET
 preferred_units = @preferred_units
,pref_last_on = @pref_last_on
,mail_dating = @mail_dating
,mail_romance = @mail_romance
,mail_intimate = @mail_intimate
,pref_clubll_signup = @pref_clubll_signup
,localePref = @localePref
,searchLanguageMask = @searchLanguageMask
,pref_community_checkbox = @pref_community_checkbox
,dateModified = @dateNow
WHERE user_id = @userId

IF @@error = 0
    BEGIN
        COMMIT TRAN TRAN_updPrefByUserId
        RETURN 0
    END
ELSE
    BEGIN
        ROLLBACK TRAN TRAN_updPrefByUserId
        RETURN 99
    END 
 
go
GRANT EXECUTE ON dbo.wsp_updPrefByUserId TO web
go
IF OBJECT_ID('dbo.wsp_updPrefByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updPrefByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updPrefByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_updPrefByUserId','unchained'
go
