  CREATE PROCEDURE dbo.bsp_GetGroupName  @userId int, @groupId  int , @groupName varchar(10) OUTPUT
AS
    BEGIN
        
        DECLARE @rowcnt int
        SELECT uid from Users WHERE userId=@userId
        SELECT @groupName=U.name
        FROM sysusers U, Groups U2
        WHERE U.gid = @groupId and U2.gid =@groupId 
       

        SELECT @rowcnt = @@rowcount
       -- IF @rowcnt = 1
           -- SELECT @groupName = U.name
     --   ELSE SELECT "Group Name not Found"

    END

/* ### DEFNCOPY: END OF DEFINITION */
