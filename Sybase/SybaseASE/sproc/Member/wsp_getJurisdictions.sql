IF OBJECT_ID('dbo.wsp_getJurisdictions') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getJurisdictions
    IF OBJECT_ID('dbo.wsp_getJurisdictions') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getJurisdictions >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getJurisdictions >>>'
END
go
create proc wsp_getJurisdictions
@countryId smallint
as

begin
   set nocount on

   select a.jurisdictionId, a.parentId, a.countryId, a.jurisdictionName, a.jurisdictionTypeId, b.jurisdictionTypeLabel, a.loc_ca
   from Jurisdiction a, JurisdictionType b
   where a.jurisdictionTypeId = b.jurisdictionTypeId
   and a.countryId = @countryId
   and a.parentId = a.jurisdictionId --This selects 1st level jurisdictions only
   and a.displayInLists = 1
   order by a.jurisdictionName
end
go
GRANT EXECUTE ON dbo.wsp_getJurisdictions TO web
go
IF OBJECT_ID('dbo.wsp_getJurisdictions') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getJurisdictions >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getJurisdictions >>>'
go
EXEC sp_procxmode 'dbo.wsp_getJurisdictions','unchained'
go
GRANT EXECUTE ON dbo.wsp_getJurisdictions TO web
go

