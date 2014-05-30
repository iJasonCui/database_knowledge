
CREATE PROCEDURE bsp_DisplayAletsbyDateRange @dateCreatedFrom DATETIME, @dateCreatedTo DATETIME

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

    ,U.name as groupName 

    ,H.hostName  

            ,J.jobName

            ,S.scheduleName

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

                

     FROM Alert A

     

     inner join Job J on

           A.jobId = J.jobId  

     inner join Schedule S on

     A.scheduleId  =S.scheduleId

     inner join Groups BG on

           BG.groupId=J.ownerGroup

         inner join sysusers U on

                U.gid=BG.gid

     left outer join Host H on

                                    H.hostId=J.hostId

    WHERE A.dateCreated between  @dateCreatedFrom

              and @dateCreatedTo

              

    ORDER BY 1

 

END


 
/* ### DEFNCOPY: END OF DEFINITION */
