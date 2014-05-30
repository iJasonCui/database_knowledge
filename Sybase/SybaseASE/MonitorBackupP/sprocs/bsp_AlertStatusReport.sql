CREATE PROC bsp_AlertStatusReport @dateCreatedFrom DATETIME, @dateCreatedTo DATETIME,@activeStatus char(1)
AS
BEGIN

DECLARE @Tme datetime
   
    
    SELECT @Tme = convert(datetime,'Jan 1 1900 '+substring(convert(varchar(50),@dateCreatedTo,109),13,50))
    
    IF @Tme = convert(datetime,'Jan 1 1900')
        BEGIN
            SELECT @dateCreatedTo = dateadd(dd,1,@dateCreatedTo)
        END

SELECT 
     A.alertId
    ,A.alertNotes
    ,A.createdBy
    ,A.dateCreated
    ,A.jobId
    ,A.scheduleId
    ,A.alertLevel
    ,A.executionId
    ,A.nagiosIndicator
    ,S.activeStatusInd
    ,J.activeStatusInd
    ,U.name as groupName 
	,H.hostName 
	,J.jobName
	,S.scheduleName         
    FROM Alert A
    inner join v_Job J on
        A.jobId = J.jobId
       and A.dateCreated >= J.dateModified 
       and A.dateCreated <= J.dateUpdated
    
    inner join Groups BG on
        BG.groupId=J.ownerGroup
    
    inner join sysusers U on
	    U.gid=BG.gid

    left outer join v_Schedule S on
        A.scheduleId = S.scheduleId 
        and A.dateCreated >= S.dateModified 
        and A.dateCreated <= S.dateUpdated
	left outer join Host H on
			H.hostId=J.hostId
	 
	   WHERE 
        A.dateCreated between  @dateCreatedFrom and @dateCreatedTo
        and J.activeStatusInd=@activeStatus
        and S.activeStatusInd in (NULL,@activeStatus)
        ORDER BY 1
END
/* ### DEFNCOPY: END OF DEFINITION */
