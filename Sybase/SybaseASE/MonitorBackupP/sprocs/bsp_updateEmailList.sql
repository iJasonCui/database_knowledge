
       CREATE PROCEDURE dbo.bsp_updateEmailList  

@emailId int

,@emailName  varchar(20)

,@emailDesc varchar(40)

,@activeStatusInd char(1)

,@eString varchar(1000)  

,@modifiedBy int    

AS

 

BEGIN

declare @allowedInd int

DECLARE @error INT

            ,@rowcount INT

EXEC bsp_checkEmailOwner @emailId=@emailId, @allowedInd=@allowedInd OUTPUT

 

IF @allowedInd = 1

    BEGIN

        SELECT "You are not allowed to update this Job. It belongs to a different group" as Message

        RETURN  

    END

 

BEGIN TRAN TRAN_UpdEmail    

UPDATE Email

SET 

    emailName = @emailName

    ,emailDesc = @emailDesc

    ,activeStatusInd = @activeStatusInd

    ,eString = @eString

    ,dateModified = getDate()

    ,modifiedBy  = @modifiedBy

    

WHERE emailId = @emailId

 

SELECT @error = @@error,@rowcount = @@rowcount

 

IF @error = 0 AND @rowcount = 1

            BEGIN

                        COMMIT TRAN TRAN_UpdEmail

            END

ELSE

            BEGIN

                        ROLLBACK TRAN TRAN_UpdEmail

            END

       

SELECT @error AS RESULT, @rowcount AS ROWCNT

RETURN @error

 

END


 
/* ### DEFNCOPY: END OF DEFINITION */
