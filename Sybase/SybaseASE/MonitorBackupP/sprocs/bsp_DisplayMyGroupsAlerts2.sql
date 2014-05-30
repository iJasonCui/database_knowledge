    CREATE PROCEDURE bsp_DisplayMyGroupsAlerts2 @dateCreatedFrom DATETIME, @dateCreatedTo DATETIME
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
    ,U2.name as groupName 
	,H.hostName 
	,J.jobName
	,S.scheduleName      
    FROM Alert A,Users BU, Groups BG, sysusers U, master..syslogins SL, master..sysloginroles SLR,
         master..syssrvroles SSR, sysroles SR, sysusers U2,Job J,Host H, Schedule S
         
        WHERE BU.uid=U.uid
              and BG.groupId=J.ownerGroup
              and U.suid=SL.suid
              and SL.suid=SLR.suid
              and SLR.srid=SSR.srid
              and SSR.srid=SR.id
              and SR.lrid=U2.uid
              and U2.gid=BG.gid
              and A.jobId = J.jobId
			  and H.hostId =J.hostId
              and U.uid=user_id()  
        ORDER BY 1
END
/* ### DEFNCOPY: END OF DEFINITION */
