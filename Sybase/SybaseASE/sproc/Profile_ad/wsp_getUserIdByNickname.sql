IF OBJECT_ID('dbo.wsp_getUserIdByNickname') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserIdByNickname
    IF OBJECT_ID('dbo.wsp_getUserIdByNickname') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserIdByNickname >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserIdByNickname >>>'
END
go

CREATE PROCEDURE  wsp_getUserIdByNickname
@nickname VARCHAR(16)
AS

BEGIN
	SELECT user_id FROM a_profile_dating WHERE myidentity = @nickname
END 
 
go
GRANT EXECUTE ON dbo.wsp_getUserIdByNickname TO web
go
IF OBJECT_ID('dbo.wsp_getUserIdByNickname') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserIdByNickname >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserIdByNickname >>>'
go
EXEC sp_procxmode 'dbo.wsp_getUserIdByNickname','unchained'
go
