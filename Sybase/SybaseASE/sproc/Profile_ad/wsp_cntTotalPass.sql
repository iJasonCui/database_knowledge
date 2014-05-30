IF OBJECT_ID('dbo.wsp_cntTotalPass') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntTotalPass
    IF OBJECT_ID('dbo.wsp_cntTotalPass') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntTotalPass >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntTotalPass >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author: Andy Tran
**   Date: Nov 18, 2004
**   Description: retrieves total pass for the target user
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE wsp_cntTotalPass
 @targetUserId NUMERIC(12,0)
,@cutoff       INT
AS
BEGIN
    SELECT COUNT(*)
      FROM Pass, a_profile_dating
     WHERE targetUserId = @targetUserId
       AND ISNULL(messageOnHoldStatus,'A') != 'H'
       AND user_id = userId
       AND show_prefs BETWEEN 'A' AND 'Z'
       AND laston > @cutoff

    RETURN @@error
END 
go

GRANT EXECUTE ON dbo.wsp_cntTotalPass TO web
go

IF OBJECT_ID('dbo.wsp_cntTotalPass') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_cntTotalPass >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntTotalPass >>>'
go

EXEC sp_procxmode 'dbo.wsp_cntTotalPass','unchained'
go
