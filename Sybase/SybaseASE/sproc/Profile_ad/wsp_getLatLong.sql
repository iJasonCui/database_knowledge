IF OBJECT_ID('dbo.wsp_getLatLong') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getLatLong
    IF OBJECT_ID('dbo.wsp_getLatLong') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getLatLong >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getLatLong >>>'
END
go

CREATE PROCEDURE wsp_getLatLong
@lat_rad int
,@long_rad int
,@countryId smallint
,@cityId int
,@lat_rad1 INT OUTPUT
,@long_rad1 INT OUTPUT

AS

IF ((@countryId = 244 OR @countryId = 40) AND
   (@lat_rad>157079) AND (@long_rad>0))
BEGIN
SELECT @lat_rad1=@lat_rad-157079
SELECT @long_rad1=@long_rad* (-1)
END

IF ((@lat_rad1 is null OR @long_rad1 is null) AND @cityId>0)
BEGIN
SELECT @lat_rad1=latitudeRad, @long_rad1=longitudeRad 
FROM CityNew 
WHERE cityId=@cityId
END

 
go
GRANT EXECUTE ON dbo.wsp_getLatLong TO web
go
IF OBJECT_ID('dbo.wsp_getLatLong') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getLatLong >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getLatLong >>>'
go
EXEC sp_procxmode 'dbo.wsp_getLatLong','unchained'
go
