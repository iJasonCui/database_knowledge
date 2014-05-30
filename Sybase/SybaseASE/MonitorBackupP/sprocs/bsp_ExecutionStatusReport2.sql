CREATE PROC bsp_ExecutionStatusReport2 @dateCreatedFrom DATETIME, @dateCreatedTo DATETIME,@activeStatus char(1)
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
    ,E.createdBy
    ,E.dateCreated
    ,E.executionNote
    ,E.logLocation
    ,E.executionStatus
    ,E.jobSpecificCode
    ,E.jobId
    ,S.scheduleName
    ,S.activeStatusInd
    ,J.activeStatusInd
    ,J.jobName
    ,U.name as groupName  
	,H.hostName     
    FROM Execution E 
    inner join v_Job J on
        E.jobId = J.jobId
       and E.dateCreated >= J.dateModified 
       and E.dateCreated <= J.dateUpdated
    
    inner join Groups BG on
        BG.groupId=J.ownerGroup
    
    inner join sysusers U on
	    U.gid=BG.gid

    left outer join v_Schedule S on
        E.scheduleId = S.scheduleId 
        and E.dateCreated >= S.dateModified 
        and E.dateCreated <= S.dateUpdated
 
    left outer join Host H on
			H.hostId=J.hostId	  

	   WHERE 
        E.dateCreated between  @dateCreatedFrom and @dateCreatedTo
        and J.activeStatusInd=@activeStatus
        and S.activeStatusInd in (NULL,@activeStatus)
        ORDER BY 1
END

/* ### DEFNCOPY: END OF DEFINITION */
