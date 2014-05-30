IF OBJECT_ID('dbo.wsp_getProfileForIndex') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getProfileForIndex
    IF OBJECT_ID('dbo.wsp_getProfileForIndex') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getProfileForIndex >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getProfileForIndex >>>'
END
go

CREATE PROCEDURE  wsp_getProfileForIndex
@userId NUMERIC(12,0)
AS

BEGIN
    SELECT  
         p.user_id,laston,myidentity,gender,
         convert( char(6), birthdate, 112) as birthdateString,
         DATEDIFF(YEAR, birthdate, GETDATE()) as age, 
         zodiac_sign,pict,video,gallery,backstage,
         on_line,show, show_prefs,
         zipcode,lat_rad,long_rad,countryId,jurisdictionId,secondJurisdictionId,cityId,
         dateadd(ss,(created_on/86400)*86400,'1970-01-01') as createdontime,
         dateadd(ss,(laston/86400)*86400,'1970-01-01') as lastontime,
         dateadd(ss,(pictimestamp/86400)*86400,'1970-01-01') as pictime, 
         dateadd(ss,(backstagetimestamp/86400)*86400,'1970-01-01') as backstagetime, 
         dateadd(ss,(gallerytimestamp/86400)*86400,'1970-01-01') as gallerytime,
         substring(attributes, 1,1)  as body_type, 
         substring(attributes, 2,1)  as ethnic,
         substring(attributes, 3,1)  as education,
         substring(attributes, 4,1)  as smoke,
         substring(attributes, 5,1)  as religion,
         substring(attributes, 6,1)  as drink,
         substring(attributes, 7,1)  as children,
         substring(attributes, 8,1)  as child_plans,
         substring(attributes, 9,1)  as income,
         substring(attributes, 10,1) as atatchedStatus,
         substring(attributes, 11,1) as seekingCouple,
         substring(attributes, 12,1) as seekingSingleMen,
         substring(attributes, 13,1) as seekingAttachedMen,
         substring(attributes, 14,1) as seekingSingleWomen,
         substring(attributes, 15,1) as seekingAttachedWomen,
         substring(attributes, 16,1) as curious,
         substring(attributes, 17,1) as onlinesex,
         substring(attributes, 18,1) as safesex,
         substring(attributes, 19,1) as conventional,
         substring(attributes, 20,1) as swinger,
         substring(attributes, 21,1) as domsub,
         substring(attributes, 22,1) as fetishes,
         substring(attributes, 23,1) as oralSex,
         substring(attributes, 24,1) as threesome, 
         profileLanguageMask,languagesSpokenMask,headline,imow.utext, imow.interest1, imow.interest2, imow.interest3,
         country, country_area, city,
         height_cm,outdoors,sportsWatch,sportsParticipate,entertainment,hobbies
    FROM a_profile_dating p, a_dating imow
	WHERE  p.user_id = @userId  AND 
           p.user_id *= imow.user_id
	AT ISOLATION READ UNCOMMITTED

	RETURN @@error
END

 
 


go
EXEC sp_procxmode 'dbo.wsp_getProfileForIndex','unchained'
go
IF OBJECT_ID('dbo.wsp_getProfileForIndex') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getProfileForIndex >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getProfileForIndex >>>'
go
GRANT EXECUTE ON dbo.wsp_getProfileForIndex TO web
go
