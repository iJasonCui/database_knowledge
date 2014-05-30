       
CREATE PROCEDURE bsp_ScheduleI
     @scheduleId           int ,
     @jobId                int ,
     @scheduleName         varchar(10),
     @scheduleDesc         varchar(40),
     @createdBy            int,
    @cronMin1         int         ,
    @cronMin2         int         ,
    @cronMin3         int         ,
    @cronMin4         int         ,
    @cronHr1          int         ,
    @cronHr2          int         ,
    @cronHr3          int         ,
    @cronHr4          int         ,
    @cronSun          bit        ,
    @cronMon          bit        ,
    @cronTue          bit        ,
    @cronWed          bit        ,
    @cronThu          bit        ,
    @cronFri          bit        ,
    @cronSat          bit        ,
     @cronMonth               int,
     @effectiveFrom       DATETIME,
     @effectiveTo         DATETIME,
     @activeStatusInd      char(1),
     @expectedDuration     int,
     @delayBeforeAlarm     int,
     @scheduleApp          varchar(30),
     @alertLevel           int 


AS
DECLARE @error INT

	,@rowcount INT
	,@dateCreated DATETIME
    ,@dateModified DATETIME
	,@primarykey INT
    ,@allowedInd INT


SELECT @cronMin2 = CASE WHEN @cronMin2 in (@cronMin1 , @cronMin3 , @cronMin4) THEN -1 ELSE @cronMin2  END
SELECT @cronMin3 = CASE WHEN @cronMin3 in (@cronMin1 , @cronMin2 , @cronMin4) THEN -1 ELSE @cronMin3 END
SELECT @cronMin4 = CASE WHEN @cronMin4 in (@cronMin1 , @cronMin3 , @cronMin2) THEN -1 ELSE @cronMin4 END

SELECT @cronHr2 = CASE WHEN @cronHr2 in (@cronHr1 , @cronHr3 , @cronHr4) THEN -1 ELSE @cronHr2  END
SELECT @cronHr3 = CASE WHEN @cronHr3 in (@cronHr1 , @cronHr2 , @cronHr4) THEN -1 ELSE @cronHr3 END
SELECT @cronHr4 = CASE WHEN @cronHr4 in (@cronHr1 , @cronHr3 , @cronHr2) THEN -1 ELSE @cronHr4 END

EXEC bsp_checkGroupOwner @jobId=@jobId, @allowedInd=@allowedInd OUTPUT

IF @allowedInd = 1
BEGIN

  SELECT "You are not allowed to update the schedule for this Job. It belongs to a diffrent group"
  RETURN  

END


SELECT @dateCreated = GETDATE()



IF @scheduleId = NULL OR @scheduleId  = 0

BEGIN
EXEC bsp_ScheduleId  @primarykey OUTPUT

SELECT @scheduleId  = @primarykey
END

IF @scheduleId  <> NULL
BEGIN
SELECT @primarykey = @scheduleId 
		BEGIN TRAN TRAN_bsp_ScheduleId 
INSERT INTO Schedule(
     scheduleId,
     jobId ,
     scheduleName,
     scheduleDesc,
     createdBy,
     dateCreated,
     modifiedBy,
     dateModified,
    cronMin1                 ,
    cronMin2                  ,
    cronMin3                  ,
    cronMin4                  ,
    cronHr1                   ,
    cronHr2                   ,
    cronHr3                   ,
    cronHr4                   ,
    cronSun                  ,
    cronMon                  ,
    cronTue                  ,
    cronWed                  ,
    cronThu                  ,
    cronFri                  ,
    cronSat                  ,
     cronMonth,
     effectiveFrom,
     effectiveTo,
     activeStatusInd,
     expectedDuration,
     delayBeforeAlarm,
     scheduleApp,
     alertLevel  )

values (
     @scheduleId,
     @jobId ,
     @scheduleName,
     @scheduleDesc,
     @createdBy,
     @dateCreated,
     @createdBy,
     @dateCreated,
    @cronMin1                 ,
    @cronMin2                  ,
    @cronMin3                  ,
    @cronMin4                  ,
    @cronHr1                   ,
    @cronHr2                   ,
    @cronHr3                   ,
    @cronHr4                   ,
    @cronSun                  ,
    @cronMon                  ,
    @cronTue                  ,
    @cronWed                  ,
    @cronThu                  ,
    @cronFri                  ,
    @cronSat                  ,
     @cronMonth,
     @effectiveFrom,
     @effectiveTo,
     @activeStatusInd,
     @expectedDuration,
     @delayBeforeAlarm,
     @scheduleApp,
     @alertLevel  )

			SELECT @error = @@error,@rowcount = @@rowcount

			IF @error = 0
				BEGIN
					COMMIT TRAN TRAN_bsp_ScheduleId
				END
			ELSE
				BEGIN
					ROLLBACK TRAN TRAN_bsp_ScheduleId
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
