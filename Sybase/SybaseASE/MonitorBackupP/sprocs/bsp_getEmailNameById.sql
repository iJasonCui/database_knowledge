
       CREATE PROCEDURE dbo.bsp_getEmailNameById  

       @emailId int = 0

AS

 

BEGIN

                        IF EXISTS (SELECT 1 FROM Email        where emailId = @emailId)

                            select emailName from Email where emailId = @emailId

                        ELSE

                                    SELECT "N/A" as emailName

    END


 
/* ### DEFNCOPY: END OF DEFINITION */
