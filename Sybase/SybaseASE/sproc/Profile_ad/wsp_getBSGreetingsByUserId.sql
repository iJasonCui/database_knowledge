IF OBJECT_ID('dbo.wsp_getBSGreetingsByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getBSGreetingsByUserId
    IF OBJECT_ID('dbo.wsp_getBSGreetingsByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getBSGreetingsByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getBSGreetingsByUserId >>>'
END
go
 


/******************************************************************************
**
** CREATION:
**   Author: Slobodan Kandic
**   Date: Oct 22 2002  
**   Description: retrieves all records from the backgreeting table for the given user.
**          
** REVISION(S):
**   Author: Valeri Popov
**   Date:  Apr. 20, 2004
**   Description: added language
**
******************************************************************************/
/******************************************************************************
******************************************************************************/
CREATE PROCEDURE  wsp_getBSGreetingsByUserId
@productCode CHAR(1),
@communityCode CHAR(1),
@userId INT
AS
BEGIN

   SELECT
              user_id,
              greeting,
              timestamp,
              approved,
              language
    FROM      a_backgreeting_dating
    WHERE     user_id = @userId
    
    RETURN @@error

END 

 
 
 
go
GRANT EXECUTE ON dbo.wsp_getBSGreetingsByUserId TO web
go
IF OBJECT_ID('dbo.wsp_getBSGreetingsByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getBSGreetingsByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getBSGreetingsByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_getBSGreetingsByUserId','unchained'
go
