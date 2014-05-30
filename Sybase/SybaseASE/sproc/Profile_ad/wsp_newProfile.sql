IF OBJECT_ID('dbo.wsp_newProfile') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newProfile
    IF OBJECT_ID('dbo.wsp_newProfile') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newProfile >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newProfile >>>'
END
go
  /***********************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  June 6 2002
**   Description:  Inserts row into profile
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: November 2004
**   Description: eliminated individual attribute column updates
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: Feb 2005
**   Description: eliminated location_id
**
*************************************************************************/

CREATE PROCEDURE wsp_newProfile
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
,@gender char(1)
,@user_type char(1)
,@myidentity char(16)
,@headline char(120)
,@created_on integer
,@approved_on integer
,@username char(16)
,@show_prefs char(1)
,@approved char(1)
,@show char(1)
,@noshowdescrp char(1)
AS

BEGIN TRAN TRAN_newProfile
     INSERT INTO a_profile_dating (
              height_cm,
		      height_in,
		      birthdate,
		      country,
		      country_area,
		      city,
		      lat_rad,
		      long_rad,
		      zipcode,
		      attributes,
		      user_id,
		      gender,
		      user_type,
		      myidentity,
		      headline,
		      created_on,
		      approved_on,
		      username,
	              show_prefs,
		      approved,
		      show,
		      noshowdescrp
              )
              VALUES (
		      @height_cm,
		      @height_in,
		      @birthdate,
		      @country,
		      @country_area,
		      @city,
		      @lat_rad,
		      @long_rad,
		      @zipcode,
		      @attributes,
		      @userId,
		      @gender,
		      @user_type,
		      @myidentity,
		      @headline,
		      @created_on,
		      @approved_on,
		      @username,
		      @show_prefs,
		      @approved,
		      @show,
		      @noshowdescrp
              )
    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_newProfile
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_newProfile
            RETURN 99
        END 
 
go
GRANT EXECUTE ON dbo.wsp_newProfile TO web
go
IF OBJECT_ID('dbo.wsp_newProfile') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_newProfile >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newProfile >>>'
go
EXEC sp_procxmode 'dbo.wsp_newProfile','unchained'
go
