
    CREATE PROCEDURE dbo.bsp_SelectJobsbyJobId @jobId int

AS

    BEGIN

        SELECT 

         J.hostId,J.jobId,J.jobTypeId,J.jobName,

        J.jobDesc,J.createdBy,J.dateCreated,

        J.modifiedBy,convert(varchar(50),J.dateModified,109)as dateModified,J.scriptname,

        J.activeStatusInd,J.expectedDuration,J.delayBeforeAlarm,

        J.ownerGroup,J.scriptPath,U.name as groupName,

                        H.hostName, J.emailId,J.emailCondId, J.nagId 

        

          FROM Job J,             

         Groups BG, sysusers U , Host H

                  

              WHERE J.jobId = @jobId

         

              and U.uid=BG.gid

              and U.uid=U.gid

              and BG.groupId=J.ownerGroup

              and H.hostId=*J.hostId

              

         

 

        END


 
/* ### DEFNCOPY: END OF DEFINITION */
