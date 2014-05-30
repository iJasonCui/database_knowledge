IF OBJECT_ID('dbo.wsp_updProfileByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updProfileByUserId
    IF OBJECT_ID('dbo.wsp_updProfileByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updProfileByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updProfileByUserId >>>'
END
go
  /***********************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  June 6 2002
**   Description:  Updates row of profile
**
** REVISION(S):
**   Author: Valeri Popov
**   Date: Apr. 28, 2004
**   Description: added new Location code
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: November 2004
**   Description: eliminated individual attribute column updates
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: Feb 2005
**   Description: removed reference to location_id and showastro
**
*************************************************************************/

CREATE PROCEDURE wsp_updProfileByUserId
 @productCode char(1)
,@communityCode char(1)
,@userId numeric (12,0)
,@height_cm int
,@height_in int
,@birthdate smalldatetime
,@country char(24)
,@country_area char(32)
,@city char(32)
,@lat_rad int
,@long_rad int
,@zipcode char(10)
,@attributes char(64)
,@iscouple char(1)
,@myidentity char(16)
,@headline char(120)
,@approved_on integer
,@show_prefs char(1)
,@countryId smallint
,@jurisdictionId smallint
,@secondJurisdictionId smallint
,@cityId int
AS

BEGIN TRAN TRAN_updProfileByUserId
     UPDATE a_profile_dating SET
	     height_cm = @height_cm,
	     height_in = @height_in,
	     birthdate = @birthdate,
	     country = @country,
	     country_area = @country_area,
             city = @city,
	     lat_rad = @lat_rad,
	     long_rad = @long_rad,
      	     zipcode = @zipcode,
	     attributes = @attributes,
             myidentity = @myidentity,
             headline = @headline,
             approved_on = @approved_on,
             show_prefs = @show_prefs,
	     countryId=@countryId,
	     jurisdictionId=@jurisdictionId,
	     secondJurisdictionId=@secondJurisdictionId,
	     cityId=@cityId
	WHERE  user_id = @userId

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_updProfileByUserId
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_updProfileByUserId
            RETURN 99
        END 
 
go
GRANT EXECUTE ON dbo.wsp_updProfileByUserId TO web
go
IF OBJECT_ID('dbo.wsp_updProfileByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updProfileByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updProfileByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_updProfileByUserId','unchained'
go
