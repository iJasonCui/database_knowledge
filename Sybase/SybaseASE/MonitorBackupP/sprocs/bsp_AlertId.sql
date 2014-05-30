 
 CREATE PROCEDURE bsp_AlertId @alertId int
 OUTPUT
AS
DECLARE @error INT

BEGIN TRAN bsp_AlertId
    UPDATE AlertId
    SET alertId = alertId + 1

    SELECT @error = @@error

    IF @error = 0
        BEGIN
            SELECT @alertId = alertId
            FROM AlertId
            COMMIT TRAN bsp_AlertId
        END
    ELSE
        BEGIN
            ROLLBACK TRAN bsp_AlertId
        END
RETURN @error

/* ### DEFNCOPY: END OF DEFINITION */
