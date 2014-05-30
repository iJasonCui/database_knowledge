IF OBJECT_ID('dbo.wsp_wcsUserInfoHistByUserName') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_wcsUserInfoHistByUserName
    IF OBJECT_ID('dbo.wsp_wcsUserInfoHistByUserName') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_wcsUserInfoHistByUserName >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_wcsUserInfoHistByUserName >>>'
END
go
CREATE PROCEDURE dbo.wsp_wcsUserInfoHistByUserName
 @rowcount  INT
,@username   VARCHAR(16)
AS
SELECT @username = UPPER(@username)

BEGIN TRAN TRAN_wcsUserInfoHistByUserName

  SET ROWCOUNT @rowcount

  SELECT user_id
  ,username
  ,CASE WHEN gender = "M" THEN "Male"
        WHEN gender = "F" THEN "Female"
        WHEN gender = "C" THEN "Couples"
        ELSE "Unknown"
   END
  ,NULL
  FROM user_info_hist
  WHERE username LIKE @username
  ORDER BY user_id DESC

  IF @@error = 0
    BEGIN
        COMMIT TRAN TRAN_wcsUserInfoHistByUserName
        RETURN 0
    END
  ELSE
    BEGIN
        ROLLBACK TRAN TRAN_wcsUserInfoHistByUserName
        RETURN 99
    END
go
IF OBJECT_ID('dbo.wsp_wcsUserInfoHistByUserName') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_wcsUserInfoHistByUserName >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_wcsUserInfoHistByUserName >>>'
go
EXEC sp_procxmode 'dbo.wsp_wcsUserInfoHistByUserName','unchained'
go
