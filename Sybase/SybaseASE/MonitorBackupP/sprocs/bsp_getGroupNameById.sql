
       CREATE PROCEDURE dbo.bsp_getGroupNameById  

       @groupId int = 0

AS

 

BEGIN

    select name from v_Groups

        where groupId = @groupId

        order by 1

    END


 
/* ### DEFNCOPY: END OF DEFINITION */
