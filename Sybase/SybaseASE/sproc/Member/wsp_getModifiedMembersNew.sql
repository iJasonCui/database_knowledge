USE Member
go
IF OBJECT_ID('dbo.wsp_getModifiedMembersNew') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getModifiedMembersNew
    IF OBJECT_ID('dbo.wsp_getModifiedMembersNew') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getModifiedMembersNew >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getModifiedMembersNew >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author: Alex Leizerowich 
**   Date:  July 3, 2008
**   Description: 
**          
******************************************************************************/
CREATE PROCEDURE wsp_getModifiedMembersNew
    @fromDateTime DATETIME,
    @toDateTime   DATETIME
AS

BEGIN
SELECT u.user_id as 'userId'
    ,u.username as 'username'
    ,u.user_type as 'userType'
    ,u.gender as 'gender'
    ,u.birthdate as 'birthdate'
    ,u.zipcode as 'zipcode'
    ,u.laston as 'laston'
    ,u.signuptime as 'signuptime'
    ,u.email as 'email'
    ,ISNULL(signup_context,'anr')
    ,c.countryLabel as 'country'
    ,j.jurisdictionName as 'provState'
    ,t.cityName as 'city'
    ,u.localePref as 'localePref' 
    ,u.languagesSpokenMask as 'languagesSpokenMask'
    ,u.signup_adcode as 'signup_adcode'
    ,u.signup_context as 'signup_context'
    ,u.firstpaytime as 'firstpaytime'
    ,u.signupIP as 'signupIP'   
    ,'' as 'TestCell'
FROM user_info u, Country c, City_new t, Jurisdiction j
WHERE u.dateModified >= @fromDateTime
    AND u.dateModified <  @toDateTime
    AND u.status='A'
    AND u.countryId=c.countryId
    AND u.cityId=t.cityId
    AND u.jurisdictionId=j.jurisdictionId
    
    RETURN @@error
END
go
EXEC sp_procxmode 'dbo.wsp_getModifiedMembersNew','unchained'
go
IF OBJECT_ID('dbo.wsp_getModifiedMembersNew') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getModifiedMembersNew >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getModifiedMembersNew >>>'
go
GRANT EXECUTE ON dbo.wsp_getModifiedMembersNew TO web
go
