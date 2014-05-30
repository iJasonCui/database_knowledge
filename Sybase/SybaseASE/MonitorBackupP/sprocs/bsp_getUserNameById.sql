
       CREATE PROCEDURE dbo.bsp_getUserNameById  

       @userId int = 0

AS

declare @suid int

 

    BEGIN

        SELECT @suid = suId

        FROM Users

        WHERE userId = @userId

 

        select name from sysusers

        where suid = @suid

        order by 1

    END


 
/* ### DEFNCOPY: END OF DEFINITION */
