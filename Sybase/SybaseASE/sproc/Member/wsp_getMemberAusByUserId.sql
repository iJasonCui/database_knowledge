IF OBJECT_ID('dbo.wsp_getMemberAusByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMemberAusByUserId
    IF OBJECT_ID('dbo.wsp_getMemberAusByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMemberAusByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMemberAusByUserId >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:  Sean Dwyer
**   Date:  November 23, 2007
**   Description:  Retrieves a list a users based on the following critera:
**                      - users who live in Sydney,Australia 
**                      - users that have been active in the last 90 days
**                      - users that are between the ages of 20yrs-40yrs
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getMemberAusByUserId
@userId NUMERIC(12,0)
AS

DECLARE @past90Days INT
DECLARE @now INT
    
    BEGIN
        SELECT @past90Days = 90 * 3600 * 24
        SELECT @now = DATEDIFF(ss,"Dec 31 20:00 1969",getdate()) 
        
        SELECT user_id
            ,username
            ,password
            ,status
            ,user_type
            ,gender
            ,birthdate
            ,user_agent
            ,zipcode
            ,lat_rad
            ,long_rad
            ,laston
            ,signuptime
            ,email
            ,universal_id
            ,universal_password
            ,ISNULL(signup_context,'anr')
            ,body_type
            ,ethnic
            ,religion
            ,smoke
            ,height_cm
            ,onhold_greeting
            ,emailStatus
            ,countryId
            ,jurisdictionId
            ,secondJurisdictionId
            ,cityId
            ,localePref 
            ,languagesSpokenMask
            ,signup_adcode
            ,firstpaytime
            ,searchLanguageMask
            ,signupIP
        FROM user_info
        WHERE countryId=13
        AND DATEDIFF(yy,birthdate,getdate()) BETWEEN 20 AND 40
        AND status = 'A'
        AND laston >=  @now - @past90Days        
        AND user_id = @userId
        
        RETURN @@error
    END

go
EXEC sp_procxmode 'dbo.wsp_getMemberAusByUserId','unchained'
go
IF OBJECT_ID('dbo.wsp_getMemberAusByUserId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getMemberAusByUserId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMemberAusByUserId >>>'
go

GRANT EXECUTE ON dbo.wsp_getMemberAusByUserId TO web
go
