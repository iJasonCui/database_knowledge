  CREATE PROCEDURE bsp_JobTypeI

 @jobTypeId   int
,@jobTypeName varchar(10)
,@jobTypeDesc varchar(40)

AS
DECLARE @error INT

	,@rowcount INT
	,@dateCreated DATETIME
	,@primarykey INT

SELECT @dateCreated = GETDATE()

IF @jobTypeId  = NULL OR @jobTypeId  = 0

BEGIN
EXEC bsp_JobTypeI @primarykey OUTPUT

SELECT @jobTypeId = @primarykey
END

IF @jobTypeId  <> NULL
BEGIN
SELECT @primarykey = @jobTypeId
		BEGIN TRAN TRAN_bsp_JobTypeI 
			INSERT INTO JobType (jobTypeId 
                ,jobTypeName
                ,jobTypeDesc
                ,dateCreated )

                values (
                 @jobTypeId
                ,@jobTypeName
                ,@jobTypeDesc
                ,@dateCreated
                )

 SELECT @error = @@error,@rowcount = @@rowcount

			IF @error = 0
				BEGIN
					COMMIT TRAN TRAN_bsp_JobTypeI
				END
			ELSE
				BEGIN
					ROLLBACK TRAN TRAN_bsp_JobTypeI
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
