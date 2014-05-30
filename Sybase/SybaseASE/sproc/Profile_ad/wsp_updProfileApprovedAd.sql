IF OBJECT_ID('dbo.wsp_updProfileApprovedAd') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updProfileApprovedAd
    IF OBJECT_ID('dbo.wsp_updProfileApprovedAd') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updProfileApprovedAd >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updProfileApprovedAd >>>'
END
go
  /*************************************************************************
**
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  May 9 2002
**   Description:  Updates the profile when an ad is approved for a user
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: April 8, 2004
**   Description: update languageMask as well
**
******************************************************************************/

CREATE PROCEDURE wsp_updProfileApprovedAd
 @productCode char(1)
,@communityCode char(1)
,@userId numeric(12,0)
,@approved_on int
,@languageMask int

AS

BEGIN TRAN TRAN_updProfileApprovedAd

    UPDATE a_profile_dating SET
    approved = 'Y',
    approved_on = @approved_on,
    profileLanguageMask = @languageMask
    WHERE user_id = @userId

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_updProfileApprovedAd
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_updProfileApprovedAd
            RETURN 99
        END 
 
go
GRANT EXECUTE ON dbo.wsp_updProfileApprovedAd TO web
go
IF OBJECT_ID('dbo.wsp_updProfileApprovedAd') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updProfileApprovedAd >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updProfileApprovedAd >>>'
go
EXEC sp_procxmode 'dbo.wsp_updProfileApprovedAd','unchained'
go
