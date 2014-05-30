CREATE PROCEDURE bsp_userId @userId int
 OUTPUT
AS
DECLARE @error INT

BEGIN TRAN bsp_UserId
    UPDATE UserId
    SET userId = userId + 1

    SELECT @error = @@error

    IF @error = 0
       BEGIN
        SELECT @userId = userId
            FROM UserId
            COMMIT TRAN bsp_UserId
        END
    ELSE
        BEGIN
            ROLLBACK TRAN bsp_UserId
        END
RETURN @error
/* ### DEFNCOPY: END OF DEFINITION */
