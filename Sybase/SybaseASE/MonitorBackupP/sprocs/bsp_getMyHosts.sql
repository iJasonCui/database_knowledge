
CREATE PROCEDURE dbo.bsp_getMyHosts  

AS

    BEGIN

        SELECT distinct hostName, hostId FROM Host order by hostName asc

    END


 
/* ### DEFNCOPY: END OF DEFINITION */
