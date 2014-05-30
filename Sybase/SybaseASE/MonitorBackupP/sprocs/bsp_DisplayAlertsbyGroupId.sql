
    CREATE PROCEDURE bsp_DisplayAlertsbyGroupId @groupId int, @dateCreatedFrom DATETIME, @dateCreatedTo DATETIME

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

            ,A.scheduleId

    ,A.alertLevel

    ,A.executionId

    ,A.nagiosIndicator

            ,J.jobName

            ,S.scheduleName

    ,U.name as groupName 

            ,H.hostName

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

                   FROM Alert A,Job J,sysusers U,Groups BG, Schedule S,Host H

             

               WHERE A.dateCreated between  @dateCreatedFrom

              and @dateCreatedTo

                                      and A.jobId = J.jobId

                                      and BG.groupId=J.ownerGroup

              and BG.groupId = @groupId 

                                      and U.gid=BG.gid

                                      and A.jobId = S.jobId

                                      and H.hostId=*J.hostId

           

 

            

        END


 
/* ### DEFNCOPY: END OF DEFINITION */
