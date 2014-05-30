USE Member
go
IF OBJECT_ID('dbo.wsp_getLLUserForSD') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getLLUserForSD
    IF OBJECT_ID('dbo.wsp_getLLUserForSD') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getLLUserForSD >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getLLUserForSD >>>'
END
go
create proc wsp_getLLUserForSD
@llUserId int
as

begin

   SELECT ui.lat_rad, ui.long_rad, ui.gender, ui.birthdate, ui.user_id,
       c.cityName, j.jurisdictionName
    FROM user_info ui
    LEFT JOIN City c 
        ON c.cityId = ui.cityId
        AND c.jurisdictionId = ui.jurisdictionId
        AND c.countryId = ui.countryId
    LEFT JOIN Jurisdiction j
        ON j.jurisdictionId = ui.jurisdictionId
        AND j.countryId = ui.countryId
    WHERE ui.user_id = @llUserId

end
go
EXEC sp_procxmode 'dbo.wsp_getLLUserForSD','unchained'
go
IF OBJECT_ID('dbo.wsp_getLLUserForSD') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getLLUserForSD >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getLLUserForSD >>>'
go
GRANT EXECUTE ON dbo.wsp_getLLUserForSD TO web
go
