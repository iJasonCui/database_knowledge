
       CREATE PROCEDURE dbo.bsp_getEmailCondById  

       @emailCondId int = 999

AS

 

BEGIN

                        IF EXISTS (SELECT 1 FROM EmailCondition where emailCondId = @emailCondId)

                            select condition from EmailCondition

            where emailCondId = @emailCondId

        ELSE        

            select "N/A" as condition

    END


 
/* ### DEFNCOPY: END OF DEFINITION */
