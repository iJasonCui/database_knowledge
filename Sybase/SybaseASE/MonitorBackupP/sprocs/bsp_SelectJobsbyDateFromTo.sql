
      CREATE PROCEDURE dbo.bsp_SelectJobsbyDateFromTo @dateCreatedFrom DATETIME ,@dateCreatedTo DATETIME

AS

    BEGIN

    

    DECLARE @Tme datetime

    

    SELECT @Tme = convert(datetime,'Jan 1 1900 '+substring(convert(varchar(50),@dateCreatedTo,109),13,50))

    

    IF @Tme = convert(datetime,'Jan 1 1900')

        BEGIN

            SELECT @dateCreatedTo = dateadd(dd,1,@dateCreatedTo)

        END

    

        SELECT 

        J.jobId,J.jobTypeId,J.jobName,

        J.jobDesc,J.createdBy,J.dateCreated,

        J.modifiedBy,J.dateModified,J.scriptname,

        J.activeStatusInd,J.expectedDuration,J.delayBeforeAlarm,

        J.ownerGroup,J.scriptPath ,U2.name as groupName , H.hostName, J.emailId

        

          FROM Job J, Groups BG,sysusers U2 , Host H WHERE J.dateCreated >= @dateCreatedFrom

          and J.dateCreated <= @dateCreatedTo

          and BG.groupId=J.ownerGroup

          and U2.gid=BG.gid

                          and H.hostId=*J.hostId

              

         

 

        END


 
/* ### DEFNCOPY: END OF DEFINITION */
