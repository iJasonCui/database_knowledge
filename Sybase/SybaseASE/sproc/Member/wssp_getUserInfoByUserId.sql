IF OBJECT_ID('dbo.wssp_getUserInfoByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wssp_getUserInfoByUserId
    IF OBJECT_ID('dbo.wssp_getUserInfoByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wssp_getUserInfoByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wssp_getUserInfoByUserId >>>'
END
go
 /***********************************************************************
**
** CREATION:
**   Author:  FS
**   Date:  Dec 1 2008
**   Description:  Retrieves user info for a given user id - used by WS membership - cloned after wssp_getUserInfoByUserId
**
** REVISION(S):
**
*************************************************************************/

CREATE PROCEDURE  wssp_getUserInfoByUserId
@userId NUMERIC(12,0)
AS

BEGIN
SELECT 
     -- account info 
     user_id
    ,email     
    ,username
    ,password
    ,laston    
    -- status
    ,status
    ,user_type
    ,emailStatus    
    ,onhold_greeting    
    -- basic attributes      
    ,gender
    ,birthdate
    -- location 
    ,zipcode
    ,lat_rad
    ,long_rad
    ,countryId
    ,jurisdictionId
    ,secondJurisdictionId
    ,cityId    
    -- extended attributes    
    ,body_type
    ,ethnic
    ,religion
    ,smoke
    ,height_cm    
    -- prefs
    ,localePref 
    ,languagesSpokenMask    
    ,searchLanguageMask
    ,preferred_units
    -- reporting (signup        
    ,signuptime
    ,ISNULL(signup_context,'anr')
    ,signup_adcode
    ,firstpaytime
    ,signupIP
    ,user_agent    
FROM user_info
WHERE user_id = @userId
AND user_type IN ('F','P')

RETURN @@error
END

go
IF OBJECT_ID('dbo.wssp_getUserInfoByUserId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wssp_getUserInfoByUserId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wssp_getUserInfoByUserId >>>'
go
EXEC sp_procxmode 'dbo.wssp_getUserInfoByUserId','unchained'
go
GRANT EXECUTE ON dbo.wssp_getUserInfoByUserId TO web
go
