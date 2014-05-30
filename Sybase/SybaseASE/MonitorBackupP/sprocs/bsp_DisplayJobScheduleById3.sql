    CREATE PROCEDURE dbo.bsp_DisplayJobScheduleById3 @scheduleId int
AS
    BEGIN
        SELECT 
     S.scheduleId 
    ,S.jobId        
    ,S.scheduleName   
    ,S.scheduleDesc     
    ,S.createdBy       
    ,S.dateCreated    
    ,S.modifiedBy    
    ,S.dateModified    
    --,S.cronMin        
    --,S.cronHr           
   -- ,S.cronDay         
    --,S.cronMon         
   -- ,S.cronWD          
    ,S.effectiveFrom    
    ,S.effectiveTo      
    ,S.activeStatusInd  
    ,S.expectedDuration 
    ,S.delayBeforeAlarm
    ,S.scheduleApp      
    ,S.alertLevel             
       
        FROM Schedule S
                  
        WHERE S.scheduleId = @scheduleId

             -- and S.activeStatusInd = "Y"
                 
    END

/* ### DEFNCOPY: END OF DEFINITION */
