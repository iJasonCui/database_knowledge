IF OBJECT_ID('dbo.wsp_wcsUserInfoByPassword') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_wcsUserInfoByPassword
    IF OBJECT_ID('dbo.wsp_wcsUserInfoByPassword') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_wcsUserInfoByPassword >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_wcsUserInfoByPassword >>>'
END
go
CREATE PROCEDURE dbo.wsp_wcsUserInfoByPassword
 @rowcount  INT
,@password   VARCHAR(129)
AS
SELECT @password = UPPER(@password)

DECLARE @getDateGMT DATETIME
DECLARE @getHourGMT INT

EXEC wsp_GetDateGMT @getDateGMT OUTPUT
SELECT @getHourGMT = DATEPART(hh, @getDateGMT)

IF @getHourGMT > 21 OR @getHourGMT < 13
BEGIN
   SELECT 0 AS user_id, 'Pls run 8am-4pm' AS password, "Unknown" AS gender   

END
ELSE BEGIN 

BEGIN TRAN TRAN_wcsUserInfoByPassword

  SET ROWCOUNT @rowcount

  SELECT user_id
  ,username
  ,password
  ,CASE WHEN gender = "M" THEN "Male"
        WHEN gender = "F" THEN "Female"
        WHEN gender = "C" THEN "Couples"
        ELSE "Unknown"
   END
  FROM user_info
  WHERE password LIKE @password
  ORDER BY user_id DESC
  AT ISOLATION READ UNCOMMITTED

  IF @@error = 0
    BEGIN
        COMMIT TRAN TRAN_wcsUserInfoByPassword
        RETURN 0
    END
  ELSE
    BEGIN
        ROLLBACK TRAN TRAN_wcsUserInfoByPassword
        RETURN 99
    END
END

go
GRANT EXECUTE ON dbo.wsp_wcsUserInfoByPassword TO web
go
IF OBJECT_ID('dbo.wsp_wcsUserInfoByPassword') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_wcsUserInfoByPassword >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_wcsUserInfoByPassword >>>'
go
EXEC sp_procxmode 'dbo.wsp_wcsUserInfoByPassword','unchained'
go
GRANT EXECUTE ON dbo.wsp_wcsUserInfoByPassword TO web
go
