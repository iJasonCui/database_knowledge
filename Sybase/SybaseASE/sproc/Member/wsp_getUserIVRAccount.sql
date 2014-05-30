IF OBJECT_ID('dbo.wsp_getUserIVRAccount') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserIVRAccount
    IF OBJECT_ID('dbo.wsp_getUserIVRAccount') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserIVRAccount >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserIVRAccount >>>'
END
go
  

CREATE PROCEDURE  wsp_getUserIVRAccount
@userId NUMERIC(12,0)
AS

BEGIN
	SELECT accountnum,passcode,cityId
	FROM UserIVRAccount
	WHERE userId = @userId

	RETURN @@error
END
 
go
GRANT EXECUTE ON dbo.wsp_getUserIVRAccount TO web
go
IF OBJECT_ID('dbo.wsp_getUserIVRAccount') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserIVRAccount >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserIVRAccount >>>'
go
EXEC sp_procxmode 'dbo.wsp_getUserIVRAccount','unchained'
go
