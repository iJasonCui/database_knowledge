IF OBJECT_ID('dbo.wsp_getLocaleIdFromLocale') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getLocaleIdFromLocale
    IF OBJECT_ID('dbo.wsp_getLocaleIdFromIsoLanguage') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getLocaleIdFromIsoLanguage >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getLocaleIdFromIsoLanguage >>>'
END
go
create procedure wsp_getLocaleIdFromIsoLanguage
                @language char(2)
as
begin
set nocount on
    select nl.localeId
    from NavigateLocale nl, Language l
    where l.languageId = nl.languageId
    and nl.countryId < 0
    and l.isoLanguage = @language
end

go
IF OBJECT_ID('dbo.wsp_getLocaleIdFromIsoLanguage') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getLocaleIdFromIsoLanguage >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getLocaleIdFromIsoLanguage >>>'
go
EXEC sp_procxmode 'dbo.wsp_getLocaleIdFromIsoLanguage','unchained'
go
GRANT EXECUTE ON dbo.wsp_getLocaleIdFromIsoLanguage TO web
go
