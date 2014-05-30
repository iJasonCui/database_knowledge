IF OBJECT_ID('dbo.wsp_cntNewPaidMember') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntNewPaidMember
    IF OBJECT_ID('dbo.wsp_cntNewPaidMember') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntNewPaidMember >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntNewPaidMember >>>'
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
CREATE PROCEDURE wsp_cntNewPaidMember
    @signupAdcode   VARCHAR(30),
    @startTimestamp INT,
    @endTimestamp   INT 
AS

BEGIN
    SELECT gender, 
           COUNT(*)
      FROM user_info 
     WHERE status = 'A'
       AND user_type = 'P'
       AND signup_adcode = @signupAdcode
       AND firstpaytime >= @startTimestamp
       AND firstpaytime <  @endTimestamp
     GROUP BY gender
END
go

GRANT EXECUTE ON dbo.wsp_cntNewPaidMember TO web
go

IF OBJECT_ID('dbo.wsp_cntNewPaidMember') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_cntNewPaidMember >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntNewPaidMember >>>'
go

EXEC sp_procxmode 'dbo.wsp_cntNewPaidMember', 'unchained'
go
