        CREATE PROCEDURE bsp_ScheduleU @scheduleId int,
     @scheduleName         varchar(10),
     @scheduleDesc         varchar(40),
     @modifiedBy           int,
     @dateModified         datetime,
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
     @cronMonth              int,
     @effectiveFrom        datetime,
     @effectiveTo          datetime,
     @activeStatusInd      char(1),
     @expectedDuration     int,
     @delayBeforeAlarm     int,
     @scheduleApp          varchar(30),
     @alertLevel           int 

AS
DECLARE @error INT
	,@rowcount INT
	,@newDateModified DATETIME
    ,@jobId int
    ,@allowedInd int

SELECT @cronMin2 = CASE WHEN @cronMin2 in (@cronMin1 , @cronMin3 , @cronMin4) THEN -1 ELSE @cronMin2  END
SELECT @cronMin3 = CASE WHEN @cronMin3 in (@cronMin1 , @cronMin2 , @cronMin4) THEN -1 ELSE @cronMin3 END
SELECT @cronMin4 = CASE WHEN @cronMin4 in (@cronMin1 , @cronMin3 , @cronMin2) THEN -1 ELSE @cronMin4 END

SELECT @cronHr2 = CASE WHEN @cronHr2 in (@cronHr1 , @cronHr3 , @cronHr4) THEN -1 ELSE @cronHr2  END
SELECT @cronHr3 = CASE WHEN @cronHr3 in (@cronHr1 , @cronHr2 , @cronHr4) THEN -1 ELSE @cronHr3 END
SELECT @cronHr4 = CASE WHEN @cronHr4 in (@cronHr1 , @cronHr3 , @cronHr2) THEN -1 ELSE @cronHr4 END

SELECT @jobId = jobId 
FROM Schedule
WHERE scheduleId = @scheduleId

EXEC bsp_checkGroupOwner @jobId=@jobId, @allowedInd=@allowedInd OUTPUT

IF @allowedInd = 1
BEGIN

  SELECT "You are not allowed to update the schedule for this Job. It belongs to a diffrent group"
  RETURN  

END

SELECT @newDateModified = GETDATE()

BEGIN TRAN TRAN_bsp_ScheduleU

INSERT ScheduleHist
SELECT scheduleId,
@newDateModified,
     jobId ,
     scheduleName,
     scheduleDesc,
     createdBy,
     dateCreated,
     @modifiedBy,
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
     alertLevel 
FROM Schedule
WHERE Schedule.scheduleId = @scheduleId
AND datediff(ss,dateModified,@dateModified) = 0

	SELECT @error = @@error,@rowcount = @@rowcount

	IF @error != 0
		BEGIN
            ROLLBACK TRAN TRAN_bsp_SchdeuleU
            SELECT @error AS RESULT,@rowcount AS ROWCNT
        	RETURN @error
		END

	UPDATE Schedule
	SET Schedule.scheduleId  = @scheduleId, 
Schedule.scheduleName = @scheduleName,
Schedule.scheduleDesc = @scheduleDesc,
Schedule.modifiedBy = @modifiedBy,
Schedule.dateModified = @newDateModified,
Schedule.cronMin1 =@cronMin1                ,
Schedule.cronMin2 = @cronMin2                 ,
Schedule.cronMin3  = @cronMin3                ,
Schedule.cronMin4  = @cronMin4      ,
Schedule.cronHr1  =  @cronHr1       ,
Schedule.cronHr2  =@cronHr2       ,
Schedule.cronHr3  = @cronHr3        ,
Schedule.cronHr4  = @cronHr4       ,
Schedule.cronSun  = @cronSun                ,
Schedule.cronMon  = @cronMon      ,
Schedule.cronTue  = @cronTue      ,
Schedule.cronWed  = @cronWed      ,
Schedule.cronThu  = @cronThu      ,
Schedule.cronFri  = @cronFri      ,
Schedule.cronSat  = @cronSat      ,
Schedule.cronMonth = @cronMonth ,
Schedule.effectiveFrom = @effectiveFrom,
Schedule.effectiveTo = @effectiveTo,
Schedule.activeStatusInd = @activeStatusInd,
Schedule.expectedDuration = @expectedDuration,
Schedule.delayBeforeAlarm = @delayBeforeAlarm,
Schedule.scheduleApp = @scheduleApp,
Schedule.alertLevel =  @alertLevel 

WHERE Schedule.scheduleId = @scheduleId 
 AND datediff(ss,dateModified,@dateModified) = 0


	SELECT @error = @@error,@rowcount = @@rowcount

	IF @error = 0 AND @rowcount = 1
		BEGIN
			COMMIT TRAN TRAN_bsp_ScheduleU
		END
	ELSE
		BEGIN
			ROLLBACK TRAN TRAN_bsp_ScheduleU
		END
	SELECT @error AS RESULT,@rowcount AS ROWCNT
	RETURN @error

/* ### DEFNCOPY: END OF DEFINITION */
