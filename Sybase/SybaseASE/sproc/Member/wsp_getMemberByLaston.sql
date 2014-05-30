IF OBJECT_ID('dbo.wsp_getMemberByLaston') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMemberByLaston
    IF OBJECT_ID('dbo.wsp_getMemberByLaston') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMemberByLaston >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMemberByLaston >>>'
END
go

/***********************************************************************
**
** CREATION:
**   Author: Yan Liu 
**   Date:  February 8, 2006
**   Description:  Retrieves Member list By laston 
** REVISION(S):
**   Author: Karthik Chandrashekar
**   Date: Oct 1, 2008
**   Description: Added more columns to be retrieved like username, user_type,
*                 gender, signup_context, email, email_status, countryId  
*                 and localePref for project id 02004
*************************************************************************/
CREATE PROCEDURE  wsp_getMemberByLaston
    @startLaston INT,
    @endLaston   INT 
AS

BEGIN
    SELECT user_id,
           laston,
           username, 
           user_type, 
           gender, 
           signup_context,
           email, 
           emailStatus, 
           countryId, 
           localePref
      FROM user_info 
     WHERE laston >= @startLaston
       AND laston <  @endLaston 
       AND status = 'A'
 
    RETURN @@error
END 
go

GRANT EXECUTE ON dbo.wsp_getMemberByLaston TO web
go

IF OBJECT_ID('dbo.wsp_getMemberByLaston') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getMemberByLaston >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMemberByLaston >>>'
go

EXEC sp_procxmode 'dbo.wsp_getMemberByLaston','unchained'
go
