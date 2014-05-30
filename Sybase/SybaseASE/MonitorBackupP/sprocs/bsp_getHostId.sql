 

 CREATE PROCEDURE dbo.bsp_getHostId
AS
    BEGIN
        SELECT hostId,hostName FROM Host order by hostName asc
    END
/* ### DEFNCOPY: END OF DEFINITION */
