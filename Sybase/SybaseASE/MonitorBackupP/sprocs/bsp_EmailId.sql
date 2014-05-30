
     CREATE PROCEDURE bsp_EmailId @EmailId int

 OUTPUT

AS

DECLARE @error INT

 

BEGIN TRAN bsp_EmailId

    UPDATE EmailId

    SET EmailId = EmailId + 1

 

    SELECT @error = @@error

 

    IF @error = 0

       BEGIN

        SELECT @EmailId = EmailId

            FROM EmailId

            COMMIT TRAN bsp_EmailId

        END

    ELSE

        BEGIN

            ROLLBACK TRAN bsp_EmailId

        END

RETURN @error


 

 

 
/* ### DEFNCOPY: END OF DEFINITION */
