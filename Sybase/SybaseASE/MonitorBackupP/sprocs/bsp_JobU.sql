
          CREATE PROCEDURE bsp_JobU @jobId int

,@dateModified dateTime

,@modifiedBy int

,@jobTypeId        int        

,@jobName          varchar(10)

,@jobDesc          varchar(40)

,@scriptname       varchar(30)

,@activeStatusInd  char(1)

,@expectedDuration int  

,@delayBeforeAlarm int 

,@ownerGroup       int

,@scriptPath       varchar(40)

,@hostId           int

,@emailId                         int

,@emailCondId     int

,@nagId                               int

AS

DECLARE @error INT

            ,@rowcount INT

            ,@newDateModified DATETIME

    ,@allowedInd int

            ,@hostId2 int

 

EXEC bsp_checkGroupOwner @jobId=@jobId, @allowedInd=@allowedInd OUTPUT

 

IF @allowedInd = 1

BEGIN

 

  SELECT "You are not allowed to update this Job. It belongs to a different group" as Message

  RETURN  

 

END

 

SELECT @newDateModified = GETDATE()

 

SELECT @hostId2 =(CASE WHEN @hostId = 0 THEN NULL ELSE @hostId END)

 

BEGIN TRAN TRAN_bsp_JobU

 

 

 

INSERT JobHist

SELECT jobId,

@newDateModified,

@modifiedBy,

jobTypeId,

jobName,

jobDesc,

createdBy,

dateCreated,

modifiedBy,

dateModified,

scriptname,

activeStatusInd,

expectedDuration, 

delayBeforeAlarm, 

ownerGroup, 

scriptPath,

hostId,

emailId,

emailCondId,

nagId

 

FROM Job

WHERE Job.jobId = @jobId

AND datediff(ss,dateModified,@dateModified) = 0

 

            SELECT @error = @@error,@rowcount = @@rowcount

 

            IF @error != 0

                        BEGIN

            ROLLBACK TRAN TRAN_bsp_JobU

            SELECT @error AS RESULT,@rowcount AS ROWCNT

            RETURN @error

                        END

 

 

 

 

            UPDATE Job

            SET Job.dateModified = @newDateModified,

Job.modifiedBy = @modifiedBy,

Job.jobTypeId = @jobTypeId        ,

Job.jobName =  @jobName          ,

Job.jobDesc = @jobDesc          ,

Job.scriptname = @scriptname      ,

Job.activeStatusInd=@activeStatusInd,

Job.expectedDuration = @expectedDuration,           

Job.delayBeforeAlarm = @delayBeforeAlarm, 

Job.ownerGroup = @ownerGroup ,      

Job.scriptPath = @scriptPath,

Job.hostId = @hostId2,

Job.emailId = @emailId,

Job.emailCondId = @emailCondId,

Job.nagId = @nagId

 

            WHERE Job.jobId = @jobId

 AND datediff(ss,dateModified,@dateModified) = 0

 

 

            SELECT @error = @@error,@rowcount = @@rowcount

 

            IF @error = 0 AND @rowcount = 1

                        BEGIN

                                    COMMIT TRAN TRAN_bsp_JobU

                        END

            ELSE

                        BEGIN

                                    ROLLBACK TRAN TRAN_bsp_JobU

                        END

            SELECT @error AS RESULT,@rowcount AS ROWCNT

            RETURN @error


 
/* ### DEFNCOPY: END OF DEFINITION */
