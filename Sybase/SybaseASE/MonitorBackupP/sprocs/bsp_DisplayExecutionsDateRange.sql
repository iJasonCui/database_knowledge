
                     CREATE PROCEDURE bsp_DisplayExecutionsDateRange @dateCreatedFrom DATETIME, @dateCreatedTo DATETIME

AS

    BEGIN

 

                DECLARE @Tme datetime

    

    SELECT @Tme = convert(datetime,'Jan 1 1900 '+substring(convert(varchar(50),@dateCreatedTo,109),13,50))

    

    IF @Tme = convert(datetime,'Jan 1 1900')

        BEGIN

            SELECT @dateCreatedTo = dateadd(dd,1,@dateCreatedTo)

        END

    

    

 Select  E.jobId

      , J.jobName

      , E.scheduleId 

              , S.scheduleName

      , E.executionId 

      , E.dateCreated 

      , E.executionNote 

      , E.logLocation 

      , E.executionStatus

      , E.jobSpecificCode 

              , U.name as groupName  

      , H.hostName

     , CASE 

                        WHEN J.emailId = null THEN 0

       ELSE J.emailId 

               END as emailId

              , CASE 

                        WHEN J.emailCondId = null THEN 999

       ELSE J.emailCondId

               END  as emailCondId

              , CASE 

                        WHEN J.nagId = null THEN 999

       ELSE J.nagId 

               END as nagId 

                

 

    FROM Execution E, Schedule S, sysusers U, Groups BG,Job J,Host H

             --Users U2,

            

               WHERE E.dateCreated  >=  @dateCreatedFrom

              and E.dateCreated  <= @dateCreatedTo

                      and E.scheduleId *= S.scheduleId

                      --and U.suid=U2.suId

              --and U.uid=U2.uid

              --and U2.userId= J.createdBy

                                      and E.jobId = J.jobId

                                      and U.gid=BG.gid

                                      and BG.groupId=J.ownerGroup 

              and H.hostId=*J.hostId

            

    

        END


 
/* ### DEFNCOPY: END OF DEFINITION */
