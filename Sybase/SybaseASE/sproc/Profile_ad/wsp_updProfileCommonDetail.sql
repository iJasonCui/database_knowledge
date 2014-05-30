IF OBJECT_ID('dbo.wsp_updProfileCommonDetail') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updProfileCommonDetail
    IF OBJECT_ID('dbo.wsp_updProfileCommonDetail') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updProfileCommonDetail >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updProfileCommonDetail >>>'
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
**   Date: Apr. 14, 2004
**   Description: Added languagesSpokenMask
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: November 2004
**   Description: eliminated individual attribute column updates
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: Feb 2005
**   Description: removed reference to location_id
**
*************************************************************************/

CREATE PROCEDURE  wsp_updProfileCommonDetail
 @productCode   CHAR(1)
,@communityCode CHAR(1)
,@userId        NUMERIC(12,0)
,@attributes    CHAR(64)
,@height_cm     tinyint
,@height_in     tinyint 
,@gender        CHAR(1)
,@birthdate     SMALLDATETIME
,@city          VARCHAR(24)
,@country       VARCHAR(24)
,@country_area  VARCHAR(32)
,@lat_rad       INT
,@long_rad      INT
,@zipcode       VARCHAR(10)
,@languagesSpokenMask INT
,@countryId smallint
,@jurisdictionId smallint
,@secondJurisdictionId smallint
,@cityId int

AS

BEGIN TRAN TRAN_updProfileCommonDetail
     UPDATE a_profile_dating SET
            attributes=@attributes,
	    height_cm=@height_cm,
	    height_in=@height_in,
            gender=@gender,
            birthdate=@birthdate,
            city=@city,
            country=@country,
            country_area=@country_area,
            lat_rad=@lat_rad,
            long_rad=@long_rad,
            zipcode=@zipcode,
            languagesSpokenMask=@languagesSpokenMask,
            countryId=@countryId,
            jurisdictionId=@jurisdictionId,
            secondJurisdictionId=@secondJurisdictionId,
            cityId=@cityId

     WHERE user_id=@userId

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_updProfileCommonDetail
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_updProfileCommonDetail
            RETURN 99
        END
 
go
GRANT EXECUTE ON dbo.wsp_updProfileCommonDetail TO web
go
IF OBJECT_ID('dbo.wsp_updProfileCommonDetail') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updProfileCommonDetail >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updProfileCommonDetail >>>'
go
EXEC sp_procxmode 'dbo.wsp_updProfileCommonDetail','unchained'
go
