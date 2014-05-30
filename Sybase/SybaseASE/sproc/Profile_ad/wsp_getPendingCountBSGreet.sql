IF OBJECT_ID('dbo.wsp_getPendingCountBSGreet') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getPendingCountBSGreet
    IF OBJECT_ID('dbo.wsp_getPendingCountBSGreet') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getPendingCountBSGreet >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getPendingCountBSGreet >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Apr 19 2002
**   Description:  retrieves count of backstage greetings pending approval
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: April 2004
**   Description: added language parameter
**
******************************************************************************/

CREATE PROCEDURE  wsp_getPendingCountBSGreet
 @productCode CHAR(1)
,@communityCode CHAR(1)
,@language TINYINT
AS

BEGIN
    SELECT count(*) AS num, min(timestamp) as minTime
    FROM a_backgreeting_dating
    WHERE approved IS NULL
    AND language = @language
    RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_getPendingCountBSGreet TO web
go
IF OBJECT_ID('dbo.wsp_getPendingCountBSGreet') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getPendingCountBSGreet >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getPendingCountBSGreet >>>'
go
EXEC sp_procxmode 'dbo.wsp_getPendingCountBSGreet','unchained'
go
