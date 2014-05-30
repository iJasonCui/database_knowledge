   CREATE PROCEDURE dbo.bsp_getMyUserId  
AS
    BEGIN
        

        SELECT userId FROM Users WHERE uid=user_id()
        

    END

/* ### DEFNCOPY: END OF DEFINITION */
