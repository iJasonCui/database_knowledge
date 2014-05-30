IF OBJECT_ID('dbo.wsp_wcsUserInfoHistByEmail') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_wcsUserInfoHistByEmail
    IF OBJECT_ID('dbo.wsp_wcsUserInfoHistByEmail') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_wcsUserInfoHistByEmail >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_wcsUserInfoHistByEmail >>>'
END
go
CREATE PROCEDURE dbo.wsp_wcsUserInfoHistByEmail
 @rowcount  INT
,@email   VARCHAR(129)
AS
SELECT @email = UPPER(@email)

BEGIN TRAN TRAN_wcsUserInfoHistByEmail

  SET ROWCOUNT @rowcount

  SELECT user_id
  ,username
  ,email
  ,CASE WHEN gender = "M" THEN "Male"
        WHEN gender = "F" THEN "Female"
        WHEN gender = "C" THEN "Couples"
        ELSE "Unknown"
   END
  FROM user_info_hist
  WHERE email LIKE @email
  ORDER BY user_id DESC

  IF @@error = 0
    BEGIN
        COMMIT TRAN TRAN_wcsUserInfoHistByEmail
        RETURN 0
    END
  ELSE
    BEGIN
        ROLLBACK TRAN TRAN_wcsUserInfoHistByEmail
        RETURN 99
    END
go
IF OBJECT_ID('dbo.wsp_wcsUserInfoHistByEmail') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_wcsUserInfoHistByEmail >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_wcsUserInfoHistByEmail >>>'
go
EXEC sp_procxmode 'dbo.wsp_wcsUserInfoHistByEmail','unchained'
go
