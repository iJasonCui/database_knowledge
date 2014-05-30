 CREATE PROCEDURE bsp_JobSpecificCodeI

     @jobSpecificCode     int
    ,@jobSpecificCodeName varchar(10)
    ,@jobSpecificCodeDesc varchar(40)
    
    

AS
DECLARE @error INT

	,@rowcount INT
	,@dateCreated DATETIME
	,@primarykey INT

SELECT @dateCreated = GETDATE()

IF @jobSpecificCode  = NULL OR @jobSpecificCode = 0

BEGIN
EXEC bsp_JobSpecificCodeI @primarykey OUTPUT

SELECT @jobSpecificCode = @primarykey
END

IF @jobSpecificCode  <> NULL
BEGIN
SELECT @primarykey = @jobSpecificCode
		BEGIN TRAN TRAN_bsp_JobSpecificCodeI 
			INSERT INTO JobSpecificCode (
                 jobSpecificCode 
                ,jobSpecificCodeName
                ,jobSpecificCodeDesc
                ,dateCreated)

                values (
                 @jobSpecificCode 
                ,@jobSpecificCodeName
                ,@jobSpecificCodeDesc
                ,@dateCreated)

 SELECT @error = @@error,@rowcount = @@rowcount

			IF @error = 0
				BEGIN
					COMMIT TRAN TRAN_bsp_JobSpecificCodeI
				END
			ELSE
				BEGIN
					ROLLBACK TRAN TRAN_bsp_JobSpecificCodeI
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
