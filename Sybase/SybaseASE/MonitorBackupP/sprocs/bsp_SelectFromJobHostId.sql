   CREATE PROCEDURE dbo.bsp_SelectFromJobHostId @hostId int
AS
    BEGIN
        IF @hostId = 0
        BEGIN
            EXEC bsp_SelectALLJobs 

        END
    ELSE

        BEGIN
        EXEC bsp_SelectJobsbyHostId @hostId
        END
END
/* ### DEFNCOPY: END OF DEFINITION */
