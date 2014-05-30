CREATE PROCEDURE bsp_DisplayAllExecution3 @dateCreatedFrom DATETIME, @dateCreatedTo DATETIME, @ownerGroup int

AS
    BEGIN

	    DECLARE @Tme datetime
    
    SELECT @Tme = convert(datetime,'Jan 1 1900 '+substring(convert(varchar(50),@dateCreatedTo,109),13,50))
    
    IF @Tme = convert(datetime,'Jan 1 1900')
        BEGIN
            SELECT @dateCreatedTo = dateadd(dd,1,@dateCreatedTo)
        END
    
    
 Select  E.jobId
      , J.jobName
      , E.scheduleId 
	  , S.scheduleName
      , E.executionId 
      , E.dateCreated 
      , E.executionNote 
      , E.logLocation 
      , E.executionStatus
      , E.jobSpecificCode 
	  , U.name as groupName   
      
	    

    FROM Execution E, Schedule S, 
	 sysusers U, Groups BG,Job J
	 --Users U2,
	
	   WHERE E.dateCreated  >=  @dateCreatedFrom
              and E.dateCreated  <= @dateCreatedTo
	          and E.scheduleId *= S.scheduleId
	          --and U.suid=U2.suId
              --and U.uid=U2.uid
              --and U2.userId= J.createdBy
			  and E.jobId = J.jobId
			  and U.gid=BG.gid
			  and BG.groupId=J.ownerGroup 
			  and J.ownerGroup= @ownerGroup
            
    
        END
/* ### DEFNCOPY: END OF DEFINITION */
