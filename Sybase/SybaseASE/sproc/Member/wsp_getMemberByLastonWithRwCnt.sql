IF OBJECT_ID('dbo.wsp_getMemberByLastonWithRwCnt') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMemberByLastonWithRwCnt
    IF OBJECT_ID('dbo.wsp_getMemberByLastonWithRwCnt') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMemberByLastonWithRwCnt >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMemberByLastonWithRwCnt >>>'
END
go

/***********************************************************************
**
** CREATION:
**   Author: Karthik Chandrashekasr 
**   Date:  October 16, 2008
**   Description:  Retrieves Member list By laston with a specific row count
** REVISION(S):
*************************************************************************/
CREATE PROCEDURE  wsp_getMemberByLastonWithRwCnt
    @rowCount    INT,
    @startLaston INT,
    @endLaston   INT 
AS

BEGIN
    SET ROWCOUNT @rowCount
    
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

GRANT EXECUTE ON dbo.wsp_getMemberByLastonWithRwCnt TO web
go

IF OBJECT_ID('dbo.wsp_getMemberByLastonWithRwCnt') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getMemberByLastonWithRwCnt >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMemberByLastonWithRwCnt >>>'
go

EXEC sp_procxmode 'dbo.wsp_getMemberByLastonWithRwCnt','unchained'
go
