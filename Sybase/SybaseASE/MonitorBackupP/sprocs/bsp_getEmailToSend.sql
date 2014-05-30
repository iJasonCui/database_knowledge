create procedure bsp_getEmailToSend

as

BEGIN

     truncate table SendEmailTmp

 

insert SendEmailTmp

select EC.jobId, J.jobName, EC.dateCreated, ECOND.condition, EC.executionId, EML.eString, 

EX.executionNote , EXS.executionStatusName

from EmailCheck EC, Job J, EmailCondition ECOND, Email EML, Execution EX, ExecutionStatus EXS

where 

    EC.processInd = 0 

and EC.jobId = J.jobId

and EC.emailCondId = ECOND.emailCondId 

and EML.emailId = J.emailId 

and EX.executionId = EC.executionId and EX.executionStatus =  EXS.executionStatus

 

insert  SendEmailTmp

select EC.jobId, J.jobName, EC.dateCreated, ECOND.condition, EC.executionId, EML.eString, null , null 

from EmailCheck EC, Job J, EmailCondition ECOND, Email EML

where 

    EC.processInd = 0 

and EC.jobId = J.jobId

and EC.emailCondId = ECOND.emailCondId 

and EML.emailId = J.emailId 

and EC.executionId = null 

     

  

     select jobName, dateCreated, condition, executionId, eString,executionNote,executionStatusName

             from SendEmailTmp 

     

     update EmailCheck

     set EmailCheck.processInd = 1

      from EmailCheck, SendEmailTmp

     where EmailCheck.jobId = SendEmailTmp.jobId 

        and  EmailCheck.dateCreated = SendEmailTmp.dateCreated 

     

end


 

 

 

 
/* ### DEFNCOPY: END OF DEFINITION */
