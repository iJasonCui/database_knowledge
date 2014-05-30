
            CREATE PROCEDURE bsp_DisplayExecutionbyGroupId @groupId int , @dateCreatedFrom DATETIME, @dateCreatedTo DATETIME

AS

    BEGIN

 

                DECLARE @Tme datetime

    

    SELECT @Tme = convert(datetime,'Jan 1 1900 '+substring(convert(varchar(50),@dateCreatedTo,109),13,50))

    

    IF @Tme = convert(datetime,'Jan 1 1900')

        BEGIN

            SELECT @dateCreatedTo = dateadd(dd,1,@dateCreatedTo)

        END

    

    

 Select E.jobId

      , J.jobName

      , E.scheduleId 

              , S.scheduleName

      , E.executionId 

      , E.dateCreated 

      , E.executionNote 

      , E.logLocation 

      , E.executionStatus

      , E.jobSpecificCode 

              , U2.name as groupName   

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

       

                 FROM Execution E, Job J, Schedule S, Groups BG, sysusers U2,Host H

         WHERE E.dateCreated between  @dateCreatedFrom

              and @dateCreatedTo

              and E.scheduleId *= S.scheduleId

              and E.jobId = J.jobId

              and BG.groupId=J.ownerGroup

              and BG.groupId = @groupId                   

                                      and H.hostId=*J.hostId  

              and U2.gid=BG.gid

              ORDER BY 1

END


 
/* ### DEFNCOPY: END OF DEFINITION */
