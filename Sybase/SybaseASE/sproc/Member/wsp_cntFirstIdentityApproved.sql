IF OBJECT_ID('dbo.wsp_cntFirstIdentityApproved') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntFirstIdentityApproved
    IF OBJECT_ID('dbo.wsp_cntFirstIdentityApproved') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntFirstIdentityApproved >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntFirstIdentityApproved >>>'
END
go
/***************************************************************************
***
**
** CREATION:
**   Author:  Yan Liu
**   Date:  April 5 2005
**   Description:  
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE wsp_cntFirstIdentityApproved
    @signupAdcode   VARCHAR(30),
    @startTimestamp INT,
    @endTimestamp   INT 
AS

BEGIN
    SELECT gender, 
           COUNT(*)
      FROM user_info 
     WHERE status = 'A'
       AND signup_context like 'a%'
       AND signup_adcode = @signupAdcode
       AND firstidentitytime >= @startTimestamp
       AND firstidentitytime <  @endTimestamp
     GROUP BY gender
END
go

GRANT EXECUTE ON dbo.wsp_cntFirstIdentityApproved TO web
go

IF OBJECT_ID('dbo.wsp_cntFirstIdentityApproved') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_cntFirstIdentityApproved >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntFirstIdentityApproved >>>'
go

EXEC sp_procxmode 'dbo.wsp_cntFirstIdentityApproved', 'unchained'
go
