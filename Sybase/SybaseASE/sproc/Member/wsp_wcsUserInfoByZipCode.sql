IF OBJECT_ID('dbo.wsp_wcsUserInfoByZipCode') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_wcsUserInfoByZipCode
    IF OBJECT_ID('dbo.wsp_wcsUserInfoByZipCode') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_wcsUserInfoByZipCode >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_wcsUserInfoByZipCode >>>'
END
go
CREATE PROCEDURE dbo.wsp_wcsUserInfoByZipCode
 @rowcount  INT
,@zipcode   VARCHAR(10)
AS
SELECT @zipcode = UPPER(@zipcode)

BEGIN TRAN TRAN_wcsUserInfoByZipCode

  SET ROWCOUNT @rowcount

  SELECT user_id
  ,username
  ,zipcode
  ,CASE WHEN gender = "M" THEN "Male"
        WHEN gender = "F" THEN "Female"
        WHEN gender = "C" THEN "Couples"
        ELSE "Unknown"
   END
  FROM user_info
  WHERE zipcode LIKE @zipcode
  ORDER BY user_id DESC
  AT ISOLATION READ UNCOMMITTED

  IF @@error = 0
    BEGIN
        COMMIT TRAN TRAN_wcsUserInfoByZipCode
        RETURN 0
    END
  ELSE
    BEGIN
        ROLLBACK TRAN TRAN_wcsUserInfoByZipCode
        RETURN 99
    END
go
GRANT EXECUTE ON dbo.wsp_wcsUserInfoByZipCode TO web
go
IF OBJECT_ID('dbo.wsp_wcsUserInfoByZipCode') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_wcsUserInfoByZipCode >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_wcsUserInfoByZipCode >>>'
go
EXEC sp_procxmode 'dbo.wsp_wcsUserInfoByZipCode','unchained'
go
GRANT EXECUTE ON dbo.wsp_wcsUserInfoByZipCode TO web
go
