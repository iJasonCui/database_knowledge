CREATE PROCEDURE dbo.bsp_DisplayScheduleHistory  @jobId int
AS
   BEGIN
SELECT 
S.scheduleId,
S.dateUpdated,
S.jobId,
S.scheduleName,
S.scheduleDesc,
S.dateCreated,
U.name as LastmodifiedBy, 	
S.dateModified,
S.effectiveFrom,
S.effectiveTo,
S.activeStatusInd,
S.expectedDuration,
S.delayBeforeAlarm,
S.scheduleApp,
S.alertLevel
                       
 FROM ScheduleHist S, Users U2, sysusers U ,Job J
                  
        WHERE S.jobId = @jobId
              and U.suid=U2.suId
              and U.uid=U2.uid
              and U2.userId=S.modifiedBy  
              and S.jobId=J.jobId
              
                 
 END
/* ### DEFNCOPY: END OF DEFINITION */
