IF OBJECT_ID('dbo.wsp_wcsUserIdByProfileName') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_wcsUserIdByProfileName
    IF OBJECT_ID('dbo.wsp_wcsUserIdByProfileName') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_wcsUserIdByProfileName >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_wcsUserIdByProfileName >>>'
END
go
CREATE PROCEDURE wsp_wcsUserIdByProfileName
 @rowcount INT
,@profileName VARCHAR(16)
AS
SELECT @profileName = UPPER(@profileName)

BEGIN
	SET ROWCOUNT @rowcount

	SELECT user_id
    ,username
    ,myidentity
  ,CASE WHEN gender = "M" THEN "Male"
        WHEN gender = "F" THEN "Female"
        WHEN gender = "C" THEN "Couples"
        ELSE "Unknown"
   END
   	FROM  a_profile_dating (INDEX ndx_identity)
	WHERE myidentity LIKE @profileName
    ORDER BY user_id DESC
    AT ISOLATION READ UNCOMMITTED

	RETURN @@error
END
go
GRANT EXECUTE ON dbo.wsp_wcsUserIdByProfileName TO web
go
IF OBJECT_ID('dbo.wsp_wcsUserIdByProfileName') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_wcsUserIdByProfileName >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_wcsUserIdByProfileName >>>'
go
EXEC sp_procxmode 'dbo.wsp_wcsUserIdByProfileName','unchained'
go
GRANT EXECUTE ON dbo.wsp_wcsUserIdByProfileName TO web
go
