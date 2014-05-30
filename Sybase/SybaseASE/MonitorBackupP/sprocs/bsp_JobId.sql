     CREATE PROCEDURE bsp_JobId @jobId int
 OUTPUT
AS
DECLARE @error INT

BEGIN TRAN bsp_JobId
    UPDATE JobId
    SET jobId = jobId + 1

    SELECT @error = @@error

    IF @error = 0
       BEGIN
        SELECT @jobId = jobId
            FROM JobId
            COMMIT TRAN bsp_JobId
        END
    ELSE
        BEGIN
            ROLLBACK TRAN bsp_JobId
        END
RETURN @error

/* ### DEFNCOPY: END OF DEFINITION */
