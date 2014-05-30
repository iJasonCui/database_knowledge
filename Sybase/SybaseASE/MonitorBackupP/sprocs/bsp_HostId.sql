 CREATE PROCEDURE bsp_HostId @hostId int

 OUTPUT

AS

DECLARE @error INT

 

BEGIN TRAN bsp_HostId

    UPDATE HostId

    SET hostId = hostId + 1

 

    SELECT @error = @@error

 

    IF @error = 0

       BEGIN

        SELECT @hostId = hostId

            FROM HostId

            COMMIT TRAN bsp_HostId

        END

    ELSE

        BEGIN

            ROLLBACK TRAN bsp_HostId

        END

RETURN @error


 

 

 
/* ### DEFNCOPY: END OF DEFINITION */
