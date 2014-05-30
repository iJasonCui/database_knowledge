   CREATE PROCEDURE dbo.bsp_SelectMyGroupJobsOld
AS
    BEGIN
 
            SELECT 
        J.jobId,J.jobTypeId,J.jobName,
        J.jobDesc,J.createdBy,J.dateCreated,
        J.modifiedBy,J.dateModified,J.scriptname,
        J.activeStatusInd,J.expectedDuration,J.delayBeforeAlarm,
        J.ownerGroup,J.scriptPath,U2.name as groupName    
                     
        FROM Job J,Users BU, Groups BG, sysusers U,
             master..syslogins SL, master..sysloginroles SLR,
             master..syssrvroles SSR, sysroles SR, sysusers U2 
        WHERE BU.uid=U.uid
              and BG.groupId=J.ownerGroup
              and U.suid=SL.suid
              and SL.suid=SLR.suid
              and SLR.srid=SSR.srid
              and SSR.srid=SR.id
              and SR.lrid=U2.uid
              and U2.gid=BG.gid
              -- and BG.activeStatusInd = "Y"
              and U.uid=user_id()    

        END
/* ### DEFNCOPY: END OF DEFINITION */
