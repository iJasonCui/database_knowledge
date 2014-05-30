
       CREATE PROCEDURE dbo.bsp_getNAGIOSdById  

       @nagId int = 999

AS

 

BEGIN

                        IF EXISTS (SELECT 1 FROM NAGIOSServices WHERE nagId = @nagId)

                            select nagName from NAGIOSServices where nagId = @nagId

                        ELSE 

                                    select "N/A" as nagName

 

    END


 
/* ### DEFNCOPY: END OF DEFINITION */
