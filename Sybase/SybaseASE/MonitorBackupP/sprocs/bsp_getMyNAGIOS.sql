
 

CREATE PROCEDURE dbo.bsp_getMyNAGIOS  

AS

    BEGIN

        SELECT nagName,nagId

        FROM NAGIOSServices

        ORDER BY 1

    END


 

 

 

 
/* ### DEFNCOPY: END OF DEFINITION */
