IF OBJECT_ID('dbo.wsp_getTrialUserByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getTrialUserByUserId
    IF OBJECT_ID('dbo.wsp_getTrialUserByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getTrialUserByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getTrialUserByUserId >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         September 20, 2004
**   Description:  retrieve trial user record by userId
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getTrialUserByUserId
@userId NUMERIC(12,0)
AS

BEGIN
    SELECT 
           trialId
          ,cardId
          ,authXactionId
          ,offerDetailId
          ,status
          ,dateCreated
          ,dateExpiry
          ,dateModified
      FROM TrialUser
     WHERE userId = @userId
    AT ISOLATION READ UNCOMMITTED

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getTrialUserByUserId TO web
go

IF OBJECT_ID('dbo.wsp_getTrialUserByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getTrialUserByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getTrialUserByUserId >>>'
go

EXEC sp_procxmode 'dbo.wsp_getTrialUserByUserId','unchained'
go
