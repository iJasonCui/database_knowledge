CREATE PROCEDURE bsp_groupId @groupId int
 OUTPUT
AS
DECLARE @error INT

BEGIN TRAN bsp_groupId
    UPDATE GroupId
    SET groupId = groupId + 1

    SELECT @error = @@error

    IF @error = 0
       BEGIN
        SELECT @groupId = groupId
            FROM GroupId
            COMMIT TRAN bsp_groupId
        END
    ELSE
        BEGIN
            ROLLBACK TRAN bsp_groupId
        END
RETURN @error
/* ### DEFNCOPY: END OF DEFINITION */
