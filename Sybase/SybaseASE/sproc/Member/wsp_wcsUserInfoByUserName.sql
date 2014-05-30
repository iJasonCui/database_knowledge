IF OBJECT_ID('dbo.wsp_wcsUserInfoByUserName') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_wcsUserInfoByUserName
    IF OBJECT_ID('dbo.wsp_wcsUserInfoByUserName') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_wcsUserInfoByUserName >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_wcsUserInfoByUserName >>>'
END
go
CREATE PROCEDURE dbo.wsp_wcsUserInfoByUserName
 @rowcount  INT
,@username   VARCHAR(16)
AS
SELECT @username = UPPER(@username)

BEGIN TRAN TRAN_wcsUserInfoByUserName

  SET ROWCOUNT @rowcount

  SELECT user_id
  ,username
  ,CASE WHEN gender = "M" THEN "Male"
        WHEN gender = "F" THEN "Female"
        WHEN gender = "C" THEN "Couples"
        ELSE "Unknown"
   END
  ,NULL
  FROM user_info
  WHERE username LIKE @username
  AND user_type NOT IN ('S','A','D','B')
  ORDER BY user_id DESC
  AT ISOLATION READ UNCOMMITTED

  IF @@error = 0
    BEGIN
        COMMIT TRAN TRAN_wcsUserInfoByUserName
        RETURN 0
    END
  ELSE
    BEGIN
        ROLLBACK TRAN TRAN_wcsUserInfoByUserName
        RETURN 99
    END
go
GRANT EXECUTE ON dbo.wsp_wcsUserInfoByUserName TO web
go
IF OBJECT_ID('dbo.wsp_wcsUserInfoByUserName') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_wcsUserInfoByUserName >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_wcsUserInfoByUserName >>>'
go
EXEC sp_procxmode 'dbo.wsp_wcsUserInfoByUserName','unchained'
go
GRANT EXECUTE ON dbo.wsp_wcsUserInfoByUserName TO web
go
