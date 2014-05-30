 CREATE PROCEDURE bsp_ExecutionId @executionId int
 OUTPUT
AS
DECLARE @error INT

BEGIN TRAN bsp_ExecutionId
    UPDATE ExecutionId
    SET executionId = executionId + 1

    SELECT @error = @@error

    IF @error = 0
        BEGIN
            SELECT @executionId = executionId
            FROM ExecutionId
            COMMIT TRAN bsp_ExecutionId
        END
    ELSE
        BEGIN
            ROLLBACK TRAN bsp_ExecutionId
        END
RETURN @error

/* ### DEFNCOPY: END OF DEFINITION */
