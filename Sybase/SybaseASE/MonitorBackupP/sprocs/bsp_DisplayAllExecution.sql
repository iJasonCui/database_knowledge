   CREATE PROCEDURE bsp_DisplayAllExecution @dateCreatedFrom datetime, @dateCreatedTo datetime
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
	  , U.name as createdBy 

    FROM Execution E, Schedule S, Users U2, sysusers U, Job J
	
	WHERE E.dateCreated  >=  @dateCreatedFrom
               and E.dateCreated  <= @dateCreatedTo
	          and E.scheduleId = S.scheduleId
	          and U.suid=U2.suId
              and U.uid=U2.uid
              and U2.userId=S.createdBy
			  and E.jobId = J.jobId

END

/* ### DEFNCOPY: END OF DEFINITION */
