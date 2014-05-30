        create proc bsp_AddAlerts
as
declare @min int, @hr int , @wd int , @month int , @scheduleId int , @jobId int ,@expectedDuration int 
,@delayBeforeAlarm int 
,@alertLevel int
,@DT1 datetime
,@DT2 datetime
,@dateCreated datetime
,@sched_cnt int
,@executionId int
,@executionNote varchar(255)
,@scheduleName varchar(10)
,@executionStatus int
,@emailCondId int

select @min = datepart(mi,getdate()) , @hr = datepart(hh,getdate()) , @wd = datepart(dw,getdate()) , @month = datepart(mm,getdate())

--select @min = 55 , @hr = 10 , @wd = 2 , @month = 7

select getdate() , @min , @hr  , @wd  , @month

--Report to Alerter Monitor

UPDATE AlertMonitor
SET dateLastRun = getdate()

--Checking Scheduled jobs

insert ScheduleCheck

select 

S.scheduleId,
getdate() as dateCreated,
S.jobId,
S.scheduleName,
S.scheduleDesc,
S.expectedDuration,
S.delayBeforeAlarm,
S.alertLevel,
convert(datetime,convert(char(2),@month)+"/"+convert(varchar(2),datepart(dd,getdate()))+"/"+convert(varchar(4),datepart(yy,getdate()))+" "+convert(char(2),@hr)+":"+convert(char(2),@min)) as DT1 ,
dateadd(mi,S.expectedDuration+S.delayBeforeAlarm,convert(datetime,convert(char(2),@month)+"/"+convert(varchar(2),datepart(dd,getdate()))+"/"+convert(varchar(4),datepart(yy,getdate()))+" "+convert(char(2),@hr)+":"+convert(char(2),@min))) as DT2  ,
0 as processInd


from  Job J , Schedule S
where
S.jobId = J.jobId
and
(@min in ( S.cronMin1 , S.cronMin2 , S.cronMin3 , S.cronMin4) 
or
(S.cronMin1 = -1 and S.cronMin2 = -1 and S.cronMin3 = -1 and S.cronMin4 = -1 )
)
and 
(@hr in (S.cronHr1 , S.cronHr2 , S.cronHr3 , S.cronHr4)
or
(S.cronHr1 = -1 and S.cronHr2 = -1 and S.cronHr3 = -1 and S.cronHr4 = -1 )
)
and
S.cronMonth in (@month ,-1)
and 
(
case when S.cronSun = 1 then 1  else Null end = @wd
or
case when S.cronMon = 1 then 2  else Null end = @wd
or
case when S.cronTue = 1 then 3  else Null end = @wd
or
case when S.cronWed = 1 then 4  else Null end = @wd
or
case when S.cronThu = 1 then 5  else Null end = @wd
or
case when S.cronFri = 1 then 6  else Null end = @wd
or
case when S.cronSat = 1 then 7  else Null end = @wd
)
and S.activeStatusInd = 'Y'
and J.activeStatusInd = 'Y'
and S.alertLevel = 2
and getdate() between S.effectiveFrom and S.effectiveTo

declare cur_sched cursor
for
select scheduleId , dateCreated , jobId ,expectedDuration
,delayBeforeAlarm ,alertLevel , DT1 , DT2 , scheduleName
 from ScheduleCheck where getdate() > DT2 and processInd = 0

open cur_sched
fetch cur_sched into
@scheduleId
,@dateCreated
,@jobId
,@expectedDuration
,@delayBeforeAlarm
,@alertLevel
,@DT1
,@DT2
,@scheduleName
while @@sqlstatus=0 
begin
    
    select @executionId = Null , @executionNote = Null
    
    select @sched_cnt = count(*) from Execution 
    where jobId = @jobId and
          scheduleId = @scheduleId and
          dateCreated between @DT1 and @DT2 
--          and  executionStatus = 1
          
    select @executionId = executionId , @executionNote = executionNote from Execution 
    where jobId = @jobId and
          scheduleId = @scheduleId and
          dateCreated between @DT1 and @DT2 and
          executionStatus = 2          

    IF @sched_cnt > 0 
       BEGIN
        
         print "1"   
        
       END
    ELSE
       BEGIN
        
         print "2"
         
         IF @executionNote = Null 
         BEGIN
             SELECT @executionNote = "Schedule '"+@scheduleName+"' for job '"+J.jobName+"' did not report in !!! Call "+G.name+"."
             FROM Job J , v_Groups G
             WHERE J.jobId = @jobId
             AND J.ownerGroup = G.groupId
         END

         EXEC bsp_AlertI
           @alertId= Null ,
           @alertNotes= @executionNote ,
           @createdBy= 9999 ,
           @jobId=@jobId ,
           @alertLevel=@alertLevel ,
           @executionId=@executionId ,
           @nagiosIndicator= 'N',
           @scheduleId = @scheduleId
           
           IF EXISTS ( SELECT 1 FROM Job WHERE jobId = @jobId and emailCondId = 0 and emailId <> NULL )
           BEGIN
            INSERT EmailCheck
            VALUES(@jobId, getdate() , 0 , @executionId , 0  )
           END
            
        
       END


    update ScheduleCheck
    set processInd = 1 
    where scheduleId = @scheduleId and
          dateCreated = @dateCreated
          


fetch cur_sched into
@scheduleId
,@dateCreated
,@jobId
,@expectedDuration
,@delayBeforeAlarm
,@alertLevel
,@DT1
,@DT2
,@scheduleName

end

close cur_sched
deallocate cursor cur_sched

delete ScheduleCheck 
where processInd = 1 
and dateCreated < dateadd(dd, -7 , getdate())


--select * from ScheduleCheck

--Check unscheduled jobs

declare cur_exec cursor
for
select executionId ,jobId , executionNote , scheduleId , executionStatus
from Execution (INDEX Execution_dte)
where 
--scheduleId is null and
--executionStatus = 2 and
    dateCreated > dateadd(dd,-1, getdate())
and executionId not in (select executionId from Alert where dateCreated  >  dateadd(dd,-1, getdate()) and executionId <> Null )

open cur_exec

fetch cur_exec into
@executionId
,@jobId
,@executionNote
,@scheduleId
,@executionStatus

while @@sqlstatus=0 
begin
         IF ( @scheduleId = Null AND @executionStatus =2 )
            SELECT @alertLevel = 2
         ELSE IF @executionStatus = 2
            BEGIN
                 SELECT @alertLevel = alertLevel
                 FROM Schedule 
                 WHERE jobId = @jobId  AND scheduleId = @scheduleId
            END
        IF ( @alertLevel = 2 AND @executionStatus = 2 )
            BEGIN   
                 EXEC bsp_AlertI
                   @alertId= Null ,
                   @alertNotes= @executionNote ,
                   @createdBy= 9999 ,
                   @jobId=@jobId ,
                   @alertLevel=@alertLevel ,
                   @executionId=@executionId ,
                   @nagiosIndicator= 'N',
                   @scheduleId = @scheduleId
            END   
           
           IF EXISTS ( SELECT 1 FROM Job WHERE jobId = @jobId and emailCondId in (0,1,2,3) and emailId <> NULL AND 
                       @executionId NOT in (SELECT executionId FROM EmailCheck) )
           BEGIN
            SELECT @emailCondId = emailCondId FROM Job WHERE jobId = @jobId
            IF ( @executionStatus = 2 AND @emailCondId in (2,3) ) OR 
               ( @executionStatus = 1 AND @emailCondId in (1,3) ) OR 
               ( @executionStatus = 2 AND @emailCondId in (0) AND @alertLevel = 2 ) 
            BEGIN
                INSERT EmailCheck
                VALUES(@jobId, getdate() , @emailCondId , @executionId , 0  )
            END
           END
           
           fetch cur_exec into
            @executionId
           ,@jobId
           ,@executionNote
           ,@scheduleId
           ,@executionStatus
            
end            

close cur_exec
deallocate cursor cur_exec


delete EmailCheck 
where processInd = 1 
and dateCreated < dateadd(dd, -7 , getdate())







/* ### DEFNCOPY: END OF DEFINITION */
