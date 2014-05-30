IF OBJECT_ID('dbo.wssp_getJurisdictionById') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wssp_getJurisdictionById
    IF OBJECT_ID('dbo.wssp_getJurisdictionById') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wssp_getJurisdictionById >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wssp_getJurisdictionById >>>'
END
go
create proc wssp_getJurisdictionById
@id int
as

begin
   set nocount on
   select a.jurisdictionId, a.parentId, a.countryId, a.jurisdictionName, a.jurisdictionTypeId, b.jurisdictionTypeLabel, a.loc_ca
   from Jurisdiction a, JurisdictionType b   
   where a.jurisdictionId = @id
   and a.jurisdictionTypeId = b.jurisdictionTypeId
   
end
go
EXEC sp_procxmode 'dbo.wssp_getJurisdictionById','unchained'
go
IF OBJECT_ID('dbo.wssp_getJurisdictionById') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wssp_getJurisdictionById >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wssp_getJurisdictionById >>>'
go
GRANT EXECUTE ON dbo.wssp_getJurisdictionById TO web
go
