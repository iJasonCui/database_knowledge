
       CREATE PROCEDURE dbo.bsp_getMyNagService  

AS

    BEGIN

        SELECT nagName,nagId

        FROM NAGIOSServices

        ORDER BY 1

    END


 

 

 
/* ### DEFNCOPY: END OF DEFINITION */
