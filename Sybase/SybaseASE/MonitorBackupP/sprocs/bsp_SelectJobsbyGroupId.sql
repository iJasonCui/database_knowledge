
    CREATE PROCEDURE dbo.bsp_SelectJobsbyGroupId @groupId int

AS

    BEGIN

        SELECT 

        J.jobId,J.jobTypeId,J.jobName,

        J.jobDesc,J.createdBy,J.dateCreated,

        J.modifiedBy,J.dateModified,J.scriptname,

        J.activeStatusInd,J.expectedDuration,J.delayBeforeAlarm,

        J.ownerGroup,J.scriptPath,U.name as groupName ,H.hostName, J.emailId   

        

          FROM Job J,             

         Groups BG, sysusers U ,Host H

                  

              WHERE J.ownerGroup = @groupId

         

              and U.uid=BG.gid

              and U.uid=U.gid

              and BG.groupId=J.ownerGroup

              and H.hostId=*J.hostId

              

         

 

        END


 
/* ### DEFNCOPY: END OF DEFINITION */
