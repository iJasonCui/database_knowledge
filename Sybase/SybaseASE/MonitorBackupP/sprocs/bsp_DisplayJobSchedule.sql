  CREATE PROCEDURE dbo.bsp_DisplayJobSchedule @groupId int, @jobId int
AS
    BEGIN
        SELECT 
     S.scheduleId 
    ,S.jobId        
    ,S.scheduleName   
    ,S.scheduleDesc     
    --,S.createdBy       
    ,S.dateCreated    
    --,S.modifiedBy 
    ,U.name as LastmodifiedBy 	   
    ,S.dateModified    
    ,S.cronMin1         
    ,S.cronMin2         
    ,S.cronMin3         
    ,S.cronMin4         
    ,S.cronHr1          
    ,S.cronHr2          
    ,S.cronHr3         
    ,S.cronHr4          
    ,S.cronSun          
    ,S.cronMon         
    ,S.cronTue          
    ,S.cronWed          
    ,S.cronThu          
    ,S.cronFri          
    ,S.cronSat         
    ,S.cronMonth        
    ,S.effectiveFrom    
    ,S.effectiveTo      
    ,S.activeStatusInd  
    ,S.expectedDuration 
    ,S.delayBeforeAlarm
    ,S.scheduleApp      
    ,S.alertLevel             

	
                       
        FROM Schedule S, Users U2, sysusers U ,Job J
                  
        WHERE S.jobId = @jobId
              and U.suid=U2.suId
              and U.uid=U2.uid
              and U2.userId=S.modifiedBy  

              and S.jobId=J.jobId
              --and S.activeStatusInd = "Y"
                 
    END

/* ### DEFNCOPY: END OF DEFINITION */
