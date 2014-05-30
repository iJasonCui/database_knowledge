IF OBJECT_ID('dbo.wsp_updProfileDetail') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updProfileDetail
    IF OBJECT_ID('dbo.wsp_updProfileDetail') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updProfileDetail >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updProfileDetail >>>'
END
go
/***********************************************************************
**
** CREATION:
**   Author:  F Schonberger 
**   Date:  Sept 17 2007
**   Description:  Cloned form updProfileCommonDetail with additionof zodiac_sign
**
** REVISION(S):
**   Author:       Eugene Huang
**   Date:         July 21, 2010
**   Description:  added profileLanguageMask
**   
*************************************************************************/

CREATE PROCEDURE  wsp_updProfileDetail
 @productCode   CHAR(1)
,@communityCode CHAR(1)
,@userId        NUMERIC(12,0)
,@attributes    CHAR(64)
,@height_cm     tinyint
,@height_in     tinyint 
,@gender        CHAR(1)
,@birthdate     SMALLDATETIME
,@zodiac_sign   char(1)
,@city          VARCHAR(24)
,@country       VARCHAR(24)
,@country_area  VARCHAR(32)
,@lat_rad       INT
,@long_rad      INT
,@zipcode       VARCHAR(10)
,@languagesSpokenMask INT
,@profileLanguageMask INT
,@countryId smallint
,@jurisdictionId smallint
,@secondJurisdictionId smallint
,@cityId int


AS

DECLARE @lat_rad1 int, @long_rad1 int
EXEC wsp_getLatLong @lat_rad, @long_rad, @countryId, @cityId, @lat_rad1 OUTPUT, @long_rad1 OUTPUT


BEGIN TRAN TRAN_updProfileDetail
     UPDATE a_profile_dating SET
              attributes=@attributes,
	      height_cm=@height_cm,
	      height_in=@height_in,
              gender=@gender,
              birthdate=@birthdate,
              zodiac_sign=@zodiac_sign,
              city=@city,
              country=@country,
              country_area=@country_area,
              lat_rad=@lat_rad,
              long_rad=@long_rad,
              lat_rad1=@lat_rad1,
              long_rad1=@long_rad1,
              zipcode=@zipcode,
              languagesSpokenMask=@languagesSpokenMask,
              profileLanguageMask=@profileLanguageMask,
              countryId=@countryId,
              jurisdictionId=@jurisdictionId,
              secondJurisdictionId=@secondJurisdictionId,
              cityId=@cityId
     WHERE user_id=@userId

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_updProfileDetail
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_updProfileDetail
            RETURN 99
        END
go
GRANT EXECUTE ON dbo.wsp_updProfileDetail TO web
go
IF OBJECT_ID('dbo.wsp_updProfileDetail') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updProfileDetail >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updProfileDetail >>>'
go

