IF OBJECT_ID('dbo.wsp_wcsUserInfoByEmail') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_wcsUserInfoByEmail
    IF OBJECT_ID('dbo.wsp_wcsUserInfoByEmail') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_wcsUserInfoByEmail >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_wcsUserInfoByEmail >>>'
END
go
CREATE PROCEDURE dbo.wsp_wcsUserInfoByEmail
 @rowcount  INT
,@email   VARCHAR(129)
AS
SELECT @email = UPPER(@email)

BEGIN TRAN TRAN_wcsUserInfoByEmail

  SET ROWCOUNT @rowcount

  SELECT user_id
  ,username
  ,email
  ,CASE WHEN gender = "M" THEN "Male"
        WHEN gender = "F" THEN "Female"
        WHEN gender = "C" THEN "Couples"
        ELSE "Unknown"
   END
  FROM user_info
  WHERE email LIKE @email
  AND user_type NOT IN ('S','A','D','B')
  ORDER BY user_id DESC
  AT ISOLATION READ UNCOMMITTED

  IF @@error = 0
    BEGIN
        COMMIT TRAN TRAN_wcsUserInfoByEmail
        RETURN 0
    END
  ELSE
    BEGIN
        ROLLBACK TRAN TRAN_wcsUserInfoByEmail
        RETURN 99
    END
go
GRANT EXECUTE ON dbo.wsp_wcsUserInfoByEmail TO web
go
IF OBJECT_ID('dbo.wsp_wcsUserInfoByEmail') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_wcsUserInfoByEmail >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_wcsUserInfoByEmail >>>'
go
EXEC sp_procxmode 'dbo.wsp_wcsUserInfoByEmail','unchained'
go
GRANT EXECUTE ON dbo.wsp_wcsUserInfoByEmail TO web
go
