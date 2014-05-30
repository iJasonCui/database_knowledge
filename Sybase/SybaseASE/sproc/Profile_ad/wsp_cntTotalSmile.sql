IF OBJECT_ID('dbo.wsp_cntTotalSmile') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntTotalSmile
    IF OBJECT_ID('dbo.wsp_cntTotalSmile') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntTotalSmile >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntTotalSmile >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author: Andy Tran
**   Date: Nov 18, 2004
**   Description: retrieves total smile for the target user
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE wsp_cntTotalSmile
 @targetUserId NUMERIC(12,0)
,@cutoff       INT
AS
BEGIN
    SELECT COUNT(*)
      FROM Smile, a_profile_dating
     WHERE targetUserId = @targetUserId
       AND user_id = userId
       AND show_prefs BETWEEN 'A' AND 'Z'
       AND seen != 'T'
       AND laston > @cutoff

    RETURN @@error
END 
go

GRANT EXECUTE ON dbo.wsp_cntTotalSmile TO web
go

IF OBJECT_ID('dbo.wsp_cntTotalSmile') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_cntTotalSmile >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntTotalSmile >>>'
go

EXEC sp_procxmode 'dbo.wsp_cntTotalSmile','unchained'
go
