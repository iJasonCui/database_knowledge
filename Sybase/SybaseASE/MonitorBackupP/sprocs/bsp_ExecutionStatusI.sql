 CREATE PROCEDURE bsp_ExecutionStatusI

     @executionStatus     int
    ,@executionStatusName varchar(10)
    ,@executionStatusDesc varchar(40)
    

AS
DECLARE @error INT

	,@rowcount INT
	,@dateCreated DATETIME
	,@primarykey INT

SELECT @dateCreated = GETDATE()

IF @executionStatus  = NULL OR @executionStatus  = 0

BEGIN
EXEC bsp_ExecutionStatusI @primarykey OUTPUT

SELECT @executionStatus = @primarykey
END

IF @executionStatus  <> NULL
BEGIN
SELECT @primarykey = @executionStatus
		BEGIN TRAN TRAN_bsp_ExecutionStatusI 
			INSERT INTO ExecutionStatus (
                 executionStatus
                ,executionStatusName
                ,executionStatusDesc 
                ,dateCreated)

                values (
                 @executionStatus
                ,@executionStatusName
                ,@executionStatusDesc 
                ,@dateCreated)

 SELECT @error = @@error,@rowcount = @@rowcount

			IF @error = 0
				BEGIN
					COMMIT TRAN TRAN_bsp_ExecutionStatusI
				END
			ELSE
				BEGIN
					ROLLBACK TRAN TRAN_bsp_ExecutionStatusI
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
