IF OBJECT_ID('dbo.wsp_getPrefLastOnByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getPrefLastOnByUserId
    IF OBJECT_ID('dbo.wsp_getPrefLastOnByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getPrefLastOnByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getPrefLastOnByUserId >>>'
END
go


CREATE PROCEDURE wsp_getPrefLastOnByUserId
 @userId NUMERIC (12,0)
AS 
BEGIN
    SELECT pref_last_on, acceptImOn FROM user_info WHERE user_id = @userId
      RETURN @@error  
END
 
go
GRANT EXECUTE ON dbo.wsp_getPrefLastOnByUserId TO web
go
IF OBJECT_ID('dbo.wsp_getPrefLastOnByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getPrefLastOnByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getPrefLastOnByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_getPrefLastOnByUserId','unchained'
go
