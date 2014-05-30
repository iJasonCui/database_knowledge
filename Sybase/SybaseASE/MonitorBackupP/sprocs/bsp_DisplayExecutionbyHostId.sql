             CREATE PROCEDURE bsp_DisplayExecutionbyHostId @hostId int , @dateCreatedFrom DATETIME, @dateCreatedTo DATETIME
AS
    BEGIN

	    DECLARE @Tme datetime
    
    SELECT @Tme = convert(datetime,'Jan 1 1900 '+substring(convert(varchar(50),@dateCreatedTo,109),13,50))
    
    IF @Tme = convert(datetime,'Jan 1 1900')
        BEGIN
            SELECT @dateCreatedTo = dateadd(dd,1,@dateCreatedTo)
        END

              
SELECT 
     E.executionId
    ,E.scheduleId
    ,S.scheduleName
    ,E.createdBy
    ,E.dateCreated
    ,E.executionNote
    ,E.logLocation
    ,E.executionStatus
    ,E.jobSpecificCode
    ,E.jobId
    ,J.jobName
    ,S.activeStatusInd
    ,J.activeStatusInd
    ,U.name as groupName
    ,H.hostName       
    FROM Execution E,Job J,sysusers U,Groups BG, Schedule S , Host H
	 
	   WHERE E.dateCreated between @dateCreatedFrom
              and @dateCreatedTo
			  and E.jobId = J.jobId           
			  and BG.groupId=J.ownerGroup 
			  and U.gid=BG.gid
              and E.scheduleId*=S.scheduleId
              and J.hostId = @hostId 
              and J.hostId = H.hostId 
              ORDER BY 1
END
/* ### DEFNCOPY: END OF DEFINITION */
