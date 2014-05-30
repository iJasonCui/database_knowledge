IF OBJECT_ID('dbo.wsp_getCityIdByNameNew') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCityIdByNameNew
    IF OBJECT_ID('dbo.wsp_getCityIdByNameNew') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCityIdByNameNew >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCityIdByNameNew >>>'
END
go
create proc wsp_getCityIdByNameNew
@countryId smallint,
@jurisdictionId smallint,
@cityName VARCHAR(120)
as

begin
   set nocount on
   
   select cityId from City_new
   where  countryId = @countryId
   and  jurisdictionId = @jurisdictionId
   and cityName = @cityName
end

go
EXEC sp_procxmode 'dbo.wsp_getCityIdByNameNew','unchained'
go
IF OBJECT_ID('dbo.wsp_getCityIdByNameNew') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getCityIdByNameNew >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCityIdByNameNew >>>'
go
GRANT EXECUTE ON dbo.wsp_getCityIdByNameNew TO web
go