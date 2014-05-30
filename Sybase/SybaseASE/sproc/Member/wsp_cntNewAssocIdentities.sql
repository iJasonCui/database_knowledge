IF OBJECT_ID('dbo.wsp_cntNewAssocIdentities') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntNewAssocIdentities
    IF OBJECT_ID('dbo.wsp_cntNewAssocIdentities') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntNewAssocIdentities >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntNewAssocIdentities >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Jan 14, 2005  
**   Description:  Counts number of new identities with associate ad codes
**          
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE  wsp_cntNewAssocIdentities
@startSeconds INT,
@endSeconds   INT,
@adcode       VARCHAR(30)
AS
BEGIN
    SELECT
        count(*)
    FROM
        user_info
    WHERE
        user_type NOT IN ('G', 'S', 'A', 'C', 'E') AND
        firstidentitytime >= @startSeconds AND
        firstidentitytime <= @endSeconds AND
        signup_adcode LIKE @adcode
        
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
END
 
go
GRANT EXECUTE ON dbo.wsp_cntNewAssocIdentities TO web
go
IF OBJECT_ID('dbo.wsp_cntNewAssocIdentities') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_cntNewAssocIdentities >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntNewAssocIdentities >>>'
go
EXEC sp_procxmode 'dbo.wsp_cntNewAssocIdentities','unchained'
go
