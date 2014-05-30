
CREATE PROCEDURE bsp_DisplayJobHistory @jobId int

AS

 BEGIN

  SELECT    

 

     JH.jobId 

    ,JH.dateUpdated 

    ,JH.jobTypeId

    ,JH.jobName 

    ,JH.jobDesc 

    ,U.name as LastmodifiedBy  

    ,JH.scriptname

    ,JH.activeStatusInd

    ,JH.expectedDuration

    ,JH.delayBeforeAlarm

    ,JH.scriptPath

    ,U3.name as ownerGroup

    ,JH.emailId

    ,JH.emailCondId            

    ,JH.nagId

FROM JobHist JH, Users U2, sysusers U ,Job J , sysusers U3 , Groups BG        

     WHERE JH.jobId = @jobId

          and U.suid=U2.suId

          and U.uid=U2.uid

          and U2.userId=JH.modifiedBy  

          and JH.jobId=J.jobId

          and U3.uid=BG.gid

          and U3.uid=U3.gid

          and BG.groupId=JH.ownerGroup

END


 
/* ### DEFNCOPY: END OF DEFINITION */
