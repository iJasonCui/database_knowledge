                           CREATE PROCEDURE dbo.bsp_getHostIdToUpdate  @hostId int
AS
--DECLARE @HTypeId int


 
    BEGIN
        
        --SELECT @HTypeId = hostId FROM Host WHERE hostId = @hostId

	IF @hostId=0

		BEGIN

        SELECT '<option value ="'as OPTIONS,0 as hostId,'"selected >'as Selected,''as hostName,'</option>'as OPTIONE
		 UNION
        SELECT '<option value ="',hostId,'">' ,hostName ,'</option>'
           FROM   Host
           WHERE  hostId <> @hostId  --case when @hostId = Null then 0 else @hostId end
            ORDER BY hostName asc
		END

	IF @hostId > 0
		BEGIN
        
		SELECT '<option value ="'as OPTIONS,hostId,'"selected >'as Selected,hostName,'</option>'as OPTIONE
         FROM Host WHERE hostId = @hostId
                UNION
        SELECT '<option value ="',hostId,'">' ,hostName ,'</option>'
         FROM   Host
          WHERE  hostId <> @hostId
          ORDER BY hostName asc

		END
    
END
/* ### DEFNCOPY: END OF DEFINITION */
