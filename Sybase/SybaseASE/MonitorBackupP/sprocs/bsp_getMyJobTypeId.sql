 CREATE PROCEDURE dbo.bsp_getMyJobTypeId
AS
    BEGIN
        SELECT jobTypeId,jobTypeDesc FROM JobType order by jobTypeId asc
    END

/* ### DEFNCOPY: END OF DEFINITION */
