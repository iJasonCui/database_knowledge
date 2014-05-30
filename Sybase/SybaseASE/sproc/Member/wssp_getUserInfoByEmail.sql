IF OBJECT_ID('dbo.wssp_getUserInfoByEmail') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wssp_getUserInfoByEmail
    IF OBJECT_ID('dbo.wssp_getUserInfoByEmail') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wssp_getUserInfoByEmail >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wssp_getUserInfoByEmail >>>'
END
go
 /***********************************************************************
**
** CREATION:
**   Author:  FS
**   Date:  Dec 1 2008
**   Description:  Retrieves user info for a given user id - used by WS membership - cloned after wssp_getUserInfoByEmail
**
** REVISION(S):
**
*************************************************************************/

CREATE PROCEDURE  wssp_getUserInfoByEmail
@email VARCHAR(129)
AS
SELECT @email = UPPER(@email)

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
WHERE email = @email
AND user_type IN ('F','P')

RETURN @@error
END

go
IF OBJECT_ID('dbo.wssp_getUserInfoByEmail') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wssp_getUserInfoByEmail >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wssp_getUserInfoByEmail >>>'
go
EXEC sp_procxmode 'dbo.wssp_getUserInfoByEmail','unchained'
go
GRANT EXECUTE ON dbo.wssp_getUserInfoByEmail TO web
go
