IF OBJECT_ID('dbo.wsp_getJurisdictionById') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getJurisdictionById
    IF OBJECT_ID('dbo.wsp_getJurisdictionById') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getJurisdictionById >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getJurisdictionById >>>'
END
go
create proc wsp_getJurisdictionById
@id int
as

begin
   set nocount on
   select a.parentId, a.countryId, leg.legacyLocation
   from   Jurisdiction a
   left join LegacyLocationMap leg  on leg.newLocation = a.jurisdictionName
   where jurisdictionId = @id
end
go
GRANT EXECUTE ON dbo.wsp_getJurisdictionById TO web
go
IF OBJECT_ID('dbo.wsp_getJurisdictionById') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getJurisdictionById >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getJurisdictionById >>>'
go
EXEC sp_procxmode 'dbo.wsp_getJurisdictionById','unchained'
go
GRANT EXECUTE ON dbo.wsp_getJurisdictionById TO web
go

