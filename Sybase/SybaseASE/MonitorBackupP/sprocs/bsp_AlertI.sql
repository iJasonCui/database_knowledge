     CREATE PROCEDURE bsp_AlertI
 @alertId     int 
,@alertNotes  varchar(255)
,@createdBy   int
--,@dateCreated datetime
,@jobId       int
,@alertLevel  int
,@executionId     int 
,@nagiosIndicator char(1)
,@scheduleId int

AS
DECLARE @error INT

	,@rowcount INT
	,@primarykey INT
    ,@dateCreated datetime

SELECT @dateCreated = GETDATE()

IF @alertId  = NULL OR @alertId = 0

BEGIN
EXEC bsp_AlertId  @primarykey OUTPUT

SELECT @alertId  = @primarykey
END

IF @alertId  <> NULL
BEGIN
SELECT @primarykey = @alertId 
		BEGIN TRAN TRAN_bsp_AlertI 
			INSERT INTO Alert 
              ( alertId
                ,alertNotes
                ,createdBy
                ,dateCreated
                ,jobId
                ,alertLevel
                ,executionId
                ,nagiosIndicator
                ,scheduleId )

                    values (
                    @alertId
                    ,@alertNotes
                    ,@createdBy
                    ,@dateCreated
                    ,@jobId
                    ,@alertLevel
                    ,@executionId
                    ,@nagiosIndicator 
                    ,@scheduleId
                    )

			SELECT @error = @@error,@rowcount = @@rowcount

			IF @error = 0
				BEGIN
					COMMIT TRAN TRAN_bsp_AlertI 
				END
			ELSE
				BEGIN
					ROLLBACK TRAN TRAN_bsp_AlertI 
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
