
CREATE PROCEDURE bsp_addNewEmailList

@emailId int

,@emailName          varchar(20) 

,@emailDesc          varchar(40) 

,@createdBy        int

,@activeStatusInd  char(1)

,@ownerGroup       int

,@eString       varchar(1000)

 

AS

DECLARE @error INT

            ,@rowcount INT

            ,@dateCreated DATETIME

            ,@primarykey INT

 

SELECT @dateCreated = GETDATE()

 

IF @emailId = NULL OR @emailId = 0

 

BEGIN

  EXEC bsp_EmailId @primarykey OUTPUT

 

SELECT @emailId = @primarykey

END

 

IF @emailId <> NULL

BEGIN

SELECT @primarykey = @emailId

                        BEGIN TRAN TRAN_bsp_addNewEmailList

                                    INSERT INTO Email (

 emailId

,dateCreated

,createdBy

,dateModified

,modifiedBy 

,emailName          

,emailDesc          

,eString

,activeStatusInd       

,ownerGroup

)

 

values (

@emailId

,@dateCreated

,@createdBy

,@dateCreated

,@createdBy 

,@emailName          

,@emailDesc          

,@eString

,@activeStatusInd        

,@ownerGroup      

)

 

                                    SELECT @error = @@error,@rowcount = @@rowcount

 

                                    IF @error = 0

                                                BEGIN

                                                            COMMIT TRAN TRAN_bsp_addNewEmailList

                                                END

                                    ELSE

                                                BEGIN

                                                            ROLLBACK TRAN TRAN_bsp_addNewEmailList

                                                END

                                    SELECT @error AS RESULT,@rowcount AS ROWCNT,@primarykey AS PRIMKEY

                                    RETURN @error

END

ELSE

BEGIN

                        SELECT @error = -9999

                        SELECT @error AS RESULT,@rowcount AS ROWCNT,@primarykey AS PRIMKEY

                        RETURN @error

            END


 
/* ### DEFNCOPY: END OF DEFINITION */
