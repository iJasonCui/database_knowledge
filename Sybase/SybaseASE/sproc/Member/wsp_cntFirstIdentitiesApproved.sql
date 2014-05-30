IF OBJECT_ID('dbo.wsp_cntFirstIdentitiesApproved') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntFirstIdentitiesApproved
    IF OBJECT_ID('dbo.wsp_cntFirstIdentitiesApproved') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntFirstIdentitiesApproved >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntFirstIdentitiesApproved >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Jan 7, 2005  
**   Description:  Counts number of new users with approved identities within time range 
**          
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE  wsp_cntFirstIdentitiesApproved
@startSeconds INT,
@endSeconds   INT
AS
BEGIN
    SELECT
        count(*)
    FROM
        user_info
    WHERE
        user_type NOT IN ('G', 'S', 'A', 'C', 'E') AND
        firstidentitytime >= @startSeconds AND
        firstidentitytime <= @endSeconds
        
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
END
 
go
GRANT EXECUTE ON dbo.wsp_cntFirstIdentitiesApproved TO web
go
IF OBJECT_ID('dbo.wsp_cntFirstIdentitiesApproved') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_cntFirstIdentitiesApproved >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntFirstIdentitiesApproved >>>'
go
EXEC sp_procxmode 'dbo.wsp_cntFirstIdentitiesApproved','unchained'
go
