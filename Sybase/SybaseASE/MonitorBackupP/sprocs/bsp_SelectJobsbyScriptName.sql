
      CREATE PROCEDURE dbo.bsp_SelectJobsbyScriptName @scriptname varchar(30)

AS

    BEGIN

        SELECT 

        J.jobId,J.jobTypeId,J.jobName,

        J.jobDesc,J.createdBy,J.dateCreated,

        J.modifiedBy,J.dateModified,J.scriptname,

        J.activeStatusInd,J.expectedDuration,J.delayBeforeAlarm,

        J.ownerGroup,J.scriptPath ,U2.name as groupName,

                        H.hostName, J.emailId

        

          FROM Job J, Groups BG,sysusers U2, Host H WHERE J.scriptname LIKE  @scriptname

          and BG.groupId=J.ownerGroup

          and H.hostId=*J.hostId

          and U2.gid=BG.gid

              

         

 

        END


 
/* ### DEFNCOPY: END OF DEFINITION */
