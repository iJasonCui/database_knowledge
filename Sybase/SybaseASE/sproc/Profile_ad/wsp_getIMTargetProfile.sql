IF OBJECT_ID('dbo.wsp_getIMTargetProfile') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getIMTargetProfile
    IF OBJECT_ID('dbo.wsp_getIMTargetProfile') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getIMTargetProfile >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getIMTargetProfile >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Oct 2002
**   Description:  retrieves pass info between userId and target from Pass table
**
**
** REVISION(S):
**   Author:  Yan Liu   
**   Date:  September 25 2007
**   Description:  add picture info into resultset.
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getIMTargetProfile
   @productCode   CHAR(1),
   @communityCode CHAR(1),
   @userId        NUMERIC(12, 0)
AS

BEGIN
   SELECT myidentity,
          backstage,
          on_line,
          video,
          pict,
          ISNULL(profileFeatures, 0) as profileFeatures
     FROM a_profile_dating 
    WHERE user_id = @userId
   AT ISOLATION READ UNCOMMITTED

   RETURN @@error
END              
go

GRANT EXECUTE ON dbo.wsp_getIMTargetProfile TO web
go

IF OBJECT_ID('dbo.wsp_getIMTargetProfile') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getIMTargetProfile >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getIMTargetProfile >>>'
go

EXEC sp_procxmode 'dbo.wsp_getIMTargetProfile','unchained'
go
