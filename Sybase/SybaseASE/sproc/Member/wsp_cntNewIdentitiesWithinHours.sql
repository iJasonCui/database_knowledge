IF OBJECT_ID('dbo.wsp_cntNewIdentitiesWithinTime') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntNewIdentitiesWithinTime
    IF OBJECT_ID('dbo.wsp_cntNewIdentitiesWithinTime') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntNewIdentitiesWithinTime >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntNewIdentitiesWithinTime >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Jan 14, 2005  
**   Description:  Counts number of new users with approved identities within time range (non associate)
**          
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE  wsp_cntNewIdentitiesWithinTime
@startSeconds INT,
@endSeconds   INT,
@hours        INT,
@linkshareCode VARCHAR(30)
AS
BEGIN
    SELECT
        count(*)
    FROM
        user_info
    WHERE
        user_type NOT IN ('G', 'S', 'A', 'C', 'E') AND
        signup_adcode NOT LIKE 'AS%' AND
        signup_adcode != @linkshareCode AND
        signuptime >= @startSeconds AND
        signuptime <= @endSeconds AND
        firstidentitytime < signuptime + (3600 * @hours)
        
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
END
 
go
GRANT EXECUTE ON dbo.wsp_cntNewIdentitiesWithinTime TO web
go
IF OBJECT_ID('dbo.wsp_cntNewIdentitiesWithinTime') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_cntNewIdentitiesWithinTime >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntNewIdentitiesWithinTime >>>'
go
EXEC sp_procxmode 'dbo.wsp_cntNewIdentitiesWithinTime','unchained'
go
