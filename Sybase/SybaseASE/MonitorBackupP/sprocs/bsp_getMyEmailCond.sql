
       CREATE PROCEDURE dbo.bsp_getMyEmailCond  

AS

    BEGIN

     

        SELECT condition,emailCondId

        FROM EmailCondition

        ORDER BY 1

    END


 
/* ### DEFNCOPY: END OF DEFINITION */
