   CREATE PROCEDURE dbo.bsp_SelectFromAlertbyHost @hostId int,@dateCreatedFrom DATETIME, @dateCreatedTo DATETIME
AS
    BEGIN
        IF @hostId = -1
        BEGIN
            EXEC bsp_DisplayAletsbyDateRange @dateCreatedFrom, @dateCreatedTo

        END
    ELSE

        BEGIN
        EXEC bsp_DisplayAlertsbyHostId  @dateCreatedFrom, @dateCreatedTo, @hostId
        END
END
/* ### DEFNCOPY: END OF DEFINITION */
