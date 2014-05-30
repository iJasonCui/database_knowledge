IF OBJECT_ID('dbo.wsp_updProfileCommonAttribute') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updProfileCommonAttribute
    IF OBJECT_ID('dbo.wsp_updProfileCommonAttribute') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updProfileCommonAttribute >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updProfileCommonAttribute >>>'
END
go
 /***********************************************************************
**
** CREATION:
**   Author:  Jeff Yang 
**   Date:  Oct. 20 2002
**   Description:  Updates common row on profile(after creating a new profile)
**
** REVISION(S):
**   Author: Valeri Popov
**   Date: Apr. 20, 2004
**   Description: Added languagesSpokenMask
**
**   Author: Travis McCauley
**   Date: Apr. 20, 2004
**   Description: Added Location Info
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: November 2004
**   Description: added noshowdescrp parameter
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: November 2004
**   Description: eliminated individual attribute column updates
**
*************************************************************************/

CREATE PROCEDURE  wsp_updProfileCommonAttribute
 @productCode   CHAR(1)
,@communityCode CHAR(1)
,@userId NUMERIC(12,0)
,@attributes char(64)
,@height_cm tinyint
,@height_in tinyint 
,@languagesSpokenMask INT
,@countryId smallint
,@jurisdictionId smallint
,@secondJurisdictionId smallint
,@cityId int
,@noshowdescrp char(5)


AS

BEGIN TRAN TRAN_updProfileCommonAttribute
     UPDATE a_profile_dating SET
		      attributes=@attributes,
		      height_cm=@height_cm,
		      height_in=@height_in,
		      languagesSpokenMask=@languagesSpokenMask,
		      countryId=@countryId,
		      jurisdictionId=@jurisdictionId,
		      secondJurisdictionId=@secondJurisdictionId,
		      cityId=@cityId
     WHERE user_id=@userId

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_updProfileCommonAttribute
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_updProfileCommonAttribute
            RETURN 99
        END
 
go
GRANT EXECUTE ON dbo.wsp_updProfileCommonAttribute TO web
go
IF OBJECT_ID('dbo.wsp_updProfileCommonAttribute') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updProfileCommonAttribute >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updProfileCommonAttribute >>>'
go
EXEC sp_procxmode 'dbo.wsp_updProfileCommonAttribute','unchained'
go
