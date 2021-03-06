
     CREATE PROCEDURE dbo.bsp_SelectJobsbySscheduleName @scheduleName varchar(10)

AS

    BEGIN

        SELECT 

        J.jobId,J.jobTypeId,J.jobName,S.scheduleName,

        J.jobDesc,J.createdBy,J.dateCreated,

        J.modifiedBy,J.dateModified,J.scriptname,

        J.activeStatusInd,J.expectedDuration,J.delayBeforeAlarm,

        J.ownerGroup,J.scriptPath ,U2.name as groupName,

                        H.hostName, J.emailId

        

          FROM Job J, Groups BG,sysusers U2, Schedule S , Host H WHERE S.scheduleName LIKE  @scheduleName

          and J.jobId = S.jobId

          and BG.groupId=J.ownerGroup

          and H.hostId=*J.hostId

          and U2.gid=BG.gid

              

         

 

        END


 
/* ### DEFNCOPY: END OF DEFINITION */
