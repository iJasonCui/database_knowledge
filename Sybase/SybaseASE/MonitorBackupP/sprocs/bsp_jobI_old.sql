        CREATE PROCEDURE bsp_jobI_old
@jobId int
,@jobTypeId        int 
,@jobName          varchar(20) 
,@jobDesc          varchar(40) 
,@createdBy        int
,@scriptname       varchar(30)
,@activeStatusInd  char(1)
,@expectedDuration int  
,@delayBeforeAlarm int 
,@ownerGroup       int
,@scriptPath       varchar(40)


AS
DECLARE @error INT

	,@rowcount INT
	,@dateCreated DATETIME
	,@primarykey INT

SELECT @dateCreated = GETDATE()

IF @jobId = NULL OR @jobId = 0

BEGIN
EXEC bsp_JobId @primarykey OUTPUT

SELECT @jobId = @primarykey
END

IF @jobId <> NULL
BEGIN
SELECT @primarykey = @jobId
		BEGIN TRAN TRAN_bsp_JobI
			INSERT INTO Job (jobId
,dateCreated
,createdBy
,dateModified
,modifiedBy 
,jobTypeId        
,jobName          
,jobDesc          
,scriptname
,activeStatusInd       
,expectedDuration         
,delayBeforeAlarm 
,ownerGroup
,scriptPath )

values (
@jobId
,@dateCreated
,@createdBy
,@dateCreated
,@createdBy
,@jobTypeId        
,@jobName          
,@jobDesc          
,@scriptname
,@activeStatusInd        
,@expectedDuration          
,@delayBeforeAlarm
,@ownerGroup      
,@scriptPath
)

			SELECT @error = @@error,@rowcount = @@rowcount

			IF @error = 0
				BEGIN
					COMMIT TRAN TRAN_bsp_JobI
				END
			ELSE
				BEGIN
					ROLLBACK TRAN TRAN_bsp_JobI
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
