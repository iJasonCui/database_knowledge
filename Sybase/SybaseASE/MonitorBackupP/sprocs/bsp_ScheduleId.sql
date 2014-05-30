 
CREATE PROCEDURE bsp_ScheduleId @scheduleId int
OUTPUT
AS
DECLARE @error INT

BEGIN TRAN bsp_ScheduleId
    UPDATE ScheduleId
    SET scheduleId = scheduleId + 1

    SELECT @error = @@error

    IF @error = 0
        BEGIN
            SELECT @scheduleId = scheduleId
            FROM ScheduleId
            COMMIT TRAN bsp_ScheduleId
        END
    ELSE
        BEGIN
            ROLLBACK TRAN bsp_ScheduleId
        END
RETURN @error

/* ### DEFNCOPY: END OF DEFINITION */
