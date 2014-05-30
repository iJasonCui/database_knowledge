                  CREATE PROCEDURE dbo.bsp_getMyJobtypeIdToUpdate  @jobId int
AS
DECLARE @JTypeId int


 
    BEGIN
        
        SELECT @JTypeId =jobTypeId FROM Job WHERE jobId = @jobId

        --SELECT '<SELECT name="groupId">'
        
		SELECT '<option value ="'as OPTIONS,jobTypeId,'"selected >'as Selected,jobTypeDesc ,'</option>'as OPTIONE
         FROM JobType WHERE jobTypeId = @JTypeId
                UNION
        SELECT '<option value ="',jobTypeId,'">' ,jobTypeDesc ,'</option>'
         FROM   JobType 
          WHERE  jobTypeId <> @JTypeId
           ORDER BY 1

    END

/* ### DEFNCOPY: END OF DEFINITION */
