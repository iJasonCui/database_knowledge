  CREATE PROCEDURE dbo.bsp_SelectJobsbyDateScheduledU  @effectiveFrom DATETIME, @effectiveTo DATETIME
AS
    BEGIN

	    DECLARE @Tme datetime
    
    SELECT @Tme = convert(datetime,'Jan 1 1900 '+substring(convert(varchar(50),@effectiveTo,109),13,50))
    
    IF @Tme = convert(datetime,'Jan 1 1900')
        BEGIN
            SELECT @effectiveTo = dateadd(dd,1,@effectiveTo)
        END
    
     SELECT distinct  jobId
     into #Schedul
          from Schedule
          WHERE 
            ( effectiveFrom >=  @effectiveFrom

         and effectiveFrom <= @effectiveTo)
             or 
            (effectiveTo >= @effectiveFrom
         
         and  effectiveTo <= @effectiveTo)

    
        SELECT 
        J.jobId,J.jobTypeId,J.jobName,
        J.jobDesc,J.createdBy,J.dateCreated,
        J.modifiedBy,J.dateModified,J.scriptname,
        J.activeStatusInd,J.expectedDuration,J.delayBeforeAlarm,
        J.ownerGroup,J.scriptPath ,U2.name as groupName 
        
          FROM Job J, Groups BG,sysusers U2 , #Schedul S1
          WHERE 
          BG.groupId=J.ownerGroup
          --and J.activeStatusInd = "Y"
          and U2.gid=BG.gid
          and J.jobId = S1.jobId
    

           
         

        END
/* ### DEFNCOPY: END OF DEFINITION */
