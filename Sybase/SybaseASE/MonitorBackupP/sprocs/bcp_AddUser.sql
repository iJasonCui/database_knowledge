CREATE PROCEDURE dbo.bcp_AddUser @userName varchar(30) , @password varchar(30) , @groupName varchar(30)
AS
    BEGIN
            
            DECLARE @suid int , @uid int , @userId int
            
            EXEC sp_addlogin @userName , @password

--            execute ('GRANT ROLE '+@groupName+' to '+@userName)
            
            GRANT ROLE @groupName to @userName
            
            EXEC sp_adduser @userName , @userName       
            
            SELECT @userId = max(userId) + 1 FROm Users
            
            SELECT @suid = suid , @uid = uid FROM sysusers where name = @userName
            
            INSERT INTO Users
            (userId,
            suId,
            uid,
            dateCreated,
            createBy,
            activeStatusInd,
            dateModified,
            modifiedBy)
VALUES
            (@userId,
            @suid,
            @uid,
            getdate(),
            9999,
            'Y',
            getdate(),
            9999)

    END

/* ### DEFNCOPY: END OF DEFINITION */
