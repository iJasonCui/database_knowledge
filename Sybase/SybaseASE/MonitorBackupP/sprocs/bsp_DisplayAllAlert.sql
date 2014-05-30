              CREATE PROCEDURE bsp_DisplayAllAlert @dateCreatedFrom DATETIME, @dateCreatedTo DATETIME
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
    ,A.alertLevel
    ,A.executionId
    ,A.nagiosIndicator
    ,U.name as groupName 
	,H.hostName       
    FROM Alert A,Job J,sysusers U,Groups BG, Host H
	 
	   WHERE A.dateCreated between  @dateCreatedFrom
              and @dateCreatedTo
			  and A.jobId = J.jobId
			  and BG.groupId=J.ownerGroup 
			  and U.gid=BG.gid
			  and H.hostId =* J.hostId


            
        END
/* ### DEFNCOPY: END OF DEFINITION */
