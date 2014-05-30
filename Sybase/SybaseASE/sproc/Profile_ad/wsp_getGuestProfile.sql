IF OBJECT_ID('dbo.wsp_getGuestProfile') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getGuestProfile
    IF OBJECT_ID('dbo.wsp_getGuestProfile') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getGuestProfile >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getGuestProfile >>>'
END
go

CREATE PROCEDURE wsp_getGuestProfile
@gender char(1),
@fromAge datetime,
@toAge  datetime,
@countryId int

AS
BEGIN

  DECLARE @startingCutoff int, @now int
  SELECT @startingCutoff = DATEDIFF(ss, "Jan 1 1970", DATEADD(day, -60, getdate()))
  SELECT @now = DATEDIFF(ss, "Jan 1 1970", getdate())

  SET ROWCOUNT 50 

  SELECT profile.user_id as id, myidentity, on_line, country, city, birthdate, laston, headline, utext,
         country_area, height_in, substring(attributes, 1,1)  as body_type, jurisdictionId
    FROM a_profile_dating as profile, a_dating as imow
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y')) 
         AND laston > @startingCutoff
         --AND laston < @now
         AND profile.user_id =  imow.user_id
         AND profile.gender = @gender
         AND pict="Y"
         AND on_line="Y"
         AND birthdate <= @fromAge
         AND birthdate >= @toAge
         AND countryId = @countryId

    ORDER BY laston desc, profile.user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error

END
  
go
GRANT EXECUTE ON dbo.wsp_getGuestProfile TO web
go
IF OBJECT_ID('dbo.wsp_getGuestProfile') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getGuestProfile >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getGuestProfile >>>'
go
EXEC sp_procxmode 'dbo.wsp_getGuestProfile','unchained'
go
