    CREATE PROCEDURE dbo.bsp_SelectFromExecution @groupId int,@dateCreatedFrom DATETIME, @dateCreatedTo DATETIME
AS
    BEGIN
        IF @groupId = -1
        BEGIN
            EXEC bsp_DisplayExecutionsDateRange @dateCreatedFrom, @dateCreatedTo

        END
    ELSE IF @groupId = -2
            BEGIN
          EXEC  bsp_DisplayMyGroupExecutions @dateCreatedFrom, @dateCreatedTo


            END
    ELSE

        BEGIN
        EXEC bsp_DisplayExecutionbyGroupId @groupId, @dateCreatedFrom, @dateCreatedTo
        END
END
/* ### DEFNCOPY: END OF DEFINITION */
