   CREATE PROCEDURE dbo.bsp_SelectFromAlert @groupId int,@dateCreatedFrom DATETIME, @dateCreatedTo DATETIME
AS
    BEGIN
        IF @groupId = -1
        BEGIN
            EXEC bsp_DisplayAletsbyDateRange @dateCreatedFrom, @dateCreatedTo

        END
    ELSE IF @groupId = -2
            BEGIN
          EXEC bsp_DisplayMyGroupsAlerts @dateCreatedFrom, @dateCreatedTo


            END
    ELSE

        BEGIN
        EXEC bsp_DisplayAlertsbyGroupId @groupId, @dateCreatedFrom, @dateCreatedTo
        END
END
/* ### DEFNCOPY: END OF DEFINITION */
