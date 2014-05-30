IF OBJECT_ID('dbo.wsp_LavanotesUnsubscribe') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_LavanotesUnsubscribe
    IF OBJECT_ID('dbo.wsp_LavanotesUnsubscribe') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_LavanotesUnsubscribe >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_LavanotesUnsubscribe >>>'
END
go
 
 CREATE PROCEDURE wsp_LavanotesUnsubscribe @email varchar(128)
AS
BEGIN
   SET ROWCOUNT 1
   IF EXISTS (SELECT * FROM user_info WHERE email = @email)
   BEGIN
      BEGIN TRAN
         UPDATE user_info
            SET pref_email_news = "N"
            WHERE email = @email
         IF (SELECT @@transtate) != 0
         BEGIN
            ROLLBACK TRAN
         END

      COMMIT TRAN
   END

   IF EXISTS (SELECT * FROM GuestEmail WHERE email = @email)
   BEGIN
         UPDATE GuestEmail
            SET pref_email_news = "N"
            WHERE email = @email
         IF (SELECT @@transtate) != 0
         BEGIN
            ROLLBACK TRAN
         END

      COMMIT TRAN
   END

   SET ROWCOUNT 0

   IF (SELECT @@transtate) != 1
      RETURN 99
   ELSE
      RETURN 0

END
 
 
go
GRANT EXECUTE ON dbo.wsp_LavanotesUnsubscribe TO web
go
IF OBJECT_ID('dbo.wsp_LavanotesUnsubscribe') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_LavanotesUnsubscribe >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_LavanotesUnsubscribe >>>'
go
EXEC sp_procxmode 'dbo.wsp_LavanotesUnsubscribe','unchained'
go
