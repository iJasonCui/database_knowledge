CREATE PROCEDURE dbo.bsp_getLastExecutionStatus @jobId int , @scheduleId int
AS
    BEGIN

        
        DECLARE @maxDate datetime
        
        SELECT @maxDate = max(dateCreated ) from Execution where jobId = @jobId and scheduleId = @scheduleId
        
        SELECT executionStatus, dateCreated
        FROM Execution
        WHERE jobId = @jobId AND scheduleId = @scheduleId AND dateCreated = @maxDate


    END



/* ### DEFNCOPY: END OF DEFINITION */
