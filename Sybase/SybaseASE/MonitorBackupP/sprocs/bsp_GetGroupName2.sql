 CREATE PROCEDURE dbo.bsp_GetGroupName2  @userId int, @groupName varchar(10) OUTPUT
AS
    BEGIN
        
        DECLARE @rowcnt int,@uid int
        
        SELECT @uid=uid from Users WHERE userId=@userId
        SELECT @groupName=U.name
        FROM sysusers U, Users U2
        WHERE U.uid = @uid and U2.uid =@uid
       

        SELECT @rowcnt = @@rowcount
       -- IF @rowcnt = 1
           -- SELECT @groupName = U.name
     --   ELSE SELECT "Group Name not Found"

    END

/* ### DEFNCOPY: END OF DEFINITION */
