USE Member
go
IF OBJECT_ID('dbo.wsp_getJurisdictionIdByName') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getJurisdictionIdByName
    IF OBJECT_ID('dbo.wsp_getJurisdictionIdByName') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getJurisdictionIdByName >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getJurisdictionIdByName >>>'
END
go
create proc wsp_getJurisdictionIdByName
@countryId smallint,
@JurisdictionName VARCHAR(100)
as

begin
   set nocount on

   select a.jurisdictionId
   from Jurisdiction a
   where a.countryId = @countryId
   and  a.jurisdictionName = @JurisdictionName
   order by a.jurisdictionTypeId desc
end
go
EXEC sp_procxmode 'dbo.wsp_getJurisdictionIdByName','unchained'
go
IF OBJECT_ID('dbo.wsp_getJurisdictionIdByName') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getJurisdictionIdByName >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getJurisdictionIdByName >>>'
go
GRANT EXECUTE ON dbo.wsp_getJurisdictionIdByName TO web
go
