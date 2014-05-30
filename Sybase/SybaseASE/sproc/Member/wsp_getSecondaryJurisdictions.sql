IF OBJECT_ID('dbo.wsp_getSecondaryJurisdictions') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getSecondaryJurisdictions
    IF OBJECT_ID('dbo.wsp_getSecondaryJurisdictions') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getSecondaryJurisdictions >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getSecondaryJurisdictions >>>'
END
go
create proc wsp_getSecondaryJurisdictions
@parentId smallint
as

begin
   set nocount on

   select a.jurisdictionId, a.parentId, a.countryId, a.jurisdictionName, a.jurisdictionTypeId, b.jurisdictionTypeLabel, -1
   from Jurisdiction a, JurisdictionType b
   where a.jurisdictionTypeId = b.jurisdictionTypeId
   and a.parentId = @parentId
   and a.jurisdictionId != @parentId
   and a.displayInLists = 1
   order by a.jurisdictionName

end
go
GRANT EXECUTE ON dbo.wsp_getSecondaryJurisdictions TO web
go
IF OBJECT_ID('dbo.wsp_getSecondaryJurisdictions') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getSecondaryJurisdictions >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getSecondaryJurisdictions >>>'
go
EXEC sp_procxmode 'dbo.wsp_getSecondaryJurisdictions','unchained'
go
GRANT EXECUTE ON dbo.wsp_getSecondaryJurisdictions TO web
go

