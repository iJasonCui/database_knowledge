
       CREATE PROCEDURE dbo.bsp_getEmailToEdit  

       @emailId int = 0

AS

    BEGIN

        

SELECT Email.emailId, 

       Email.emailName, 

       Email.emailDesc, 

       Email.createdBy, 

       Email.dateCreated, 

       Email.modifiedBy, 

       Email.dateModified, 

       Email.activeStatusInd, 

       Email.ownerGroup, 

       Email.eString

        FROM Email

        WHERE emailId = @emailId

        ORDER BY 1

    END


 
/* ### DEFNCOPY: END OF DEFINITION */
