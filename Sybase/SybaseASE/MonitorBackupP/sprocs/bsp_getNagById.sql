
       CREATE PROCEDURE dbo.bsp_getNagById  

       @nagId int = 0

AS

 

BEGIN

                        if (@nagId = 0 )

                        begin 

                                                declare @nagName char(25)

                                                select @nagName = "No NAGIOS Attached"

                        end

                        else

                            select nagName from NAGIOSServices

            where nagId = @nagId

            order by 1

    END


 

 

 
/* ### DEFNCOPY: END OF DEFINITION */
