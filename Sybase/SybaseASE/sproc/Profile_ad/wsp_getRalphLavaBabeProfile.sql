IF OBJECT_ID('dbo.wsp_getRalphLavaBabeProfile') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getRalphLavaBabeProfile
    IF OBJECT_ID('dbo.wsp_getRalphLavaBabeProfile') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getRalphLavaBabeProfile >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getRalphLavaBabeProfile >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         Aug 5, 2005
**   Description:  returns Ralph Lava Babe's user profile based on userId
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getRalphLavaBabeProfile
 @productCode   CHAR(1)
,@communityCode CHAR(1)
,@userId        NUMERIC(12,0)
AS

BEGIN
    SELECT username, myidentity, birthdate, countryId, jurisdictionId, secondJurisdictionId, cityId
      FROM a_profile_dating p, a_mompictures_dating m
     WHERE p.user_id = @userId
       AND p.user_id = m.user_id
       AND p.myidentity IS NOT NULL
       AND p.approved = 'Y'
       AND p.pict = 'Y'
       AND p.show_prefs = 'Y'
       AND m.r_brand = 'Y'
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
END

go
IF OBJECT_ID('dbo.wsp_getRalphLavaBabeProfile') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getRalphLavaBabeProfile >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getRalphLavaBabeProfile >>>'
go
EXEC sp_procxmode 'dbo.wsp_getRalphLavaBabeProfile','unchained'
go
GRANT EXECUTE ON dbo.wsp_getRalphLavaBabeProfile TO web
go
