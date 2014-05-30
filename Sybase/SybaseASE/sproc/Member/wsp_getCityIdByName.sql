IF OBJECT_ID('dbo.wsp_getCityIdByName') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCityIdByName
    IF OBJECT_ID('dbo.wsp_getCityIdByName') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCityIdByName >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCityIdByName >>>'
END
go
create proc wsp_getCityIdByName
@countryId smallint,
@jurisdictionId smallint,
@cityName VARCHAR(120)
as

begin
   set nocount on
   
   select cityId from City
   where  countryId = @countryId
   and  jurisdictionId = @jurisdictionId
   and cityName = @cityName
end

go
EXEC sp_procxmode 'dbo.wsp_getCityIdByName','unchained'
go
IF OBJECT_ID('dbo.wsp_getCityIdByName') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getCityIdByName >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCityIdByName >>>'
go
GRANT EXECUTE ON dbo.wsp_getCityIdByName TO web
go