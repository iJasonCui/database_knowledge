IF OBJECT_ID('dbo.wsp_cntNewUser') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntNewUser
    IF OBJECT_ID('dbo.wsp_cntNewUser') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntNewUser >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntNewUser >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Mark Jaeckle
**   Date:  September 5 2002  
**   Description:  Counts number of new users since @daysAgo days before now.
**          
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE  wsp_cntNewUser
@daysAgo INT,
@gender CHAR
AS

DECLARE @now DATETIME,
@now_seconds INT

SELECT @now = getdate()

EXEC wsp_convertTimestamp @now, @now_seconds OUTPUT, 0

BEGIN
    SELECT
        count(*)
    FROM
        user_info (index user_info_idx3)
    WHERE
        user_type IN('F', 'P') AND
        signuptime >= (@now_seconds - 86400 * @daysAgo) AND
        signuptime <= @now_seconds AND
        gender = @gender
        
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
END
 
go
GRANT EXECUTE ON dbo.wsp_cntNewUser TO web
go
IF OBJECT_ID('dbo.wsp_cntNewUser') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_cntNewUser >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntNewUser >>>'
go
EXEC sp_procxmode 'dbo.wsp_cntNewUser','unchained'
go
