  CREATE PROCEDURE dbo.bsp_SelectFromJob @groupId int
AS
    BEGIN
        IF @groupId = -1
        BEGIN
            EXEC bsp_SelectALLJobs 

        END
    ELSE IF @groupId = -2
            BEGIN
          EXEC bsp_SelectMyGroupJobs


            END
    ELSE

        BEGIN
        EXEC bsp_SelectJobsbyGroupId @groupId 
        END
END

/* ### DEFNCOPY: END OF DEFINITION */
