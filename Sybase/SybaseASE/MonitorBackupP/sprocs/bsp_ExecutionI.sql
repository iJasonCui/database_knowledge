       CREATE PROCEDURE bsp_ExecutionI
@executionId     int        
,@scheduleId      int          
,@createdBy       int         
,@executionNote   varchar(255) 
,@logLocation     varchar(100) 
,@executionStatus int          
,@jobSpecificCode int          
,@jobId           int          

AS
DECLARE @error INT

	,@rowcount INT
	,@primarykey INT
    ,@dateCreated     datetime     

IF (NOT EXISTS (SELECT 1 FROM Schedule WHERE jobId = @jobId and scheduleId = @scheduleId )  AND (@scheduleId <> Null))
    BEGIN
        
        SELECT -9999 AS RESULT,0 AS ROWCNT,0 AS PRIMKEY
        RETURN -9999
    
    END

SELECT @dateCreated = GETDATE()

IF @executionId  = NULL OR @executionId= 0

BEGIN
EXEC bsp_ExecutionId  @primarykey OUTPUT

SELECT @executionId  = @primarykey
END

IF @executionId  <> NULL
BEGIN
SELECT @primarykey = @executionId
		BEGIN TRAN TRAN_bsp_ExecutionI
			INSERT INTO Execution
              (  executionId           
                ,scheduleId               
                ,createdBy               
                ,dateCreated         
                ,executionNote   
                ,logLocation    
                ,executionStatus          
                ,jobSpecificCode          
                ,jobId )

                    values (
                @executionId           
                ,@scheduleId               
                ,@createdBy               
                ,@dateCreated         
                ,@executionNote   
                ,@logLocation    
                ,@executionStatus          
                ,@jobSpecificCode          
                ,@jobId 
                    )

			SELECT @error = @@error,@rowcount = @@rowcount

			IF @error = 0
				BEGIN
					COMMIT TRAN TRAN_bsp_ExecutionI
				END
			ELSE
				BEGIN
					ROLLBACK TRAN TRAN_bsp_ExecutionI 
                    
                  	INSERT INTO FailedExecution
                  (  executionId           
                    ,scheduleId               
                    ,createdBy               
                    ,dateCreated         
                    ,executionNote   
                    ,logLocation    
                    ,executionStatus          
                    ,jobSpecificCode          
                    ,jobId
                    ,failError )

                        values (
                    @executionId           
                    ,@scheduleId               
                    ,@createdBy               
                    ,@dateCreated         
                    ,@executionNote   
                    ,@logLocation    
                    ,@executionStatus          
                    ,@jobSpecificCode          
                    ,@jobId 
                    ,@error
                        )
				END
			SELECT @error AS RESULT,@rowcount AS ROWCNT,@primarykey AS PRIMKEY
			RETURN @error
END
ELSE
BEGIN
		SELECT @error = -9999
		SELECT @error AS RESULT,@rowcount AS ROWCNT,@primarykey AS PRIMKEY
		RETURN @error
	END

/* ### DEFNCOPY: END OF DEFINITION */
