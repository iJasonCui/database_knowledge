IF OBJECT_ID('dbo.wsp_cntNewAssocRegistrations') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntNewAssocRegistrations
    IF OBJECT_ID('dbo.wsp_cntNewAssocRegistrations') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntNewAssocRegistrations >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntNewAssocRegistrations >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Jan 14, 2005  
**   Description:  Counts number of new members with associate ad codes
**          
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE  wsp_cntNewAssocRegistrations
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
        signuptime >= @startSeconds AND
        signuptime <= @endSeconds AND
        signup_adcode LIKE @adcode
        
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
END
 
go
GRANT EXECUTE ON dbo.wsp_cntNewAssocRegistrations TO web
go
IF OBJECT_ID('dbo.wsp_cntNewAssocRegistrations') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_cntNewAssocRegistrations >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntNewAssocRegistrations >>>'
go
EXEC sp_procxmode 'dbo.wsp_cntNewAssocRegistrations','unchained'
go
