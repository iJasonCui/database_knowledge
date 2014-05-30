IF OBJECT_ID('dbo.wsp_getLocaleIdFromLocale') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getLocaleIdFromLocale
    IF OBJECT_ID('dbo.wsp_getLocaleIdFromLocale') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getLocaleIdFromLocale >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getLocaleIdFromLocale >>>'
END
go
create procedure wsp_getLocaleIdFromLocale
                @language char(2),
                @country char(2)
as
begin
set nocount on
    select nl.localeId
    from NavigateLocale nl, Language l, Country c
    where l.languageId = nl.languageId
    and nl.countryId = c.countryId
    and l.isoLanguage = @language
    and c.countryCodeIso = @country
end

go
IF OBJECT_ID('dbo.wsp_getLocaleIdFromLocale') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getLocaleIdFromLocale >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getLocaleIdFromLocale >>>'
go
EXEC sp_procxmode 'dbo.wsp_getLocaleIdFromLocale','unchained'
go
GRANT EXECUTE ON dbo.wsp_getLocaleIdFromLocale TO web
go
