IF OBJECT_ID('dbo.wsp_getLocalefromLocaleId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getLocalefromLocaleId
    IF OBJECT_ID('dbo.wsp_getLocalefromLocaleId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getLocalefromLocaleId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getLocalefromLocaleId >>>'
END
go
create procedure wsp_getLocalefromLocaleId
                @localeId int
                --@returnLocale varchar(5) output
as
begin
set nocount on
    declare @countryId int, @languageId int, @countryCodeIso char(2), @isoLanguage char(2), @returnLocale varchar(5)
    select @countryId = countryId from NavigateLocale where localeId = @localeId
    select @languageId = languageId from NavigateLocale where localeId = @localeId
    select @isoLanguage = isoLanguage from Language where languageId = @languageId
    if exists(select 1 from Country where countryId = @countryId)
        begin
            select @countryCodeIso = countryCodeIso from Country where countryId = @countryId
            select @returnLocale = @isoLanguage + '_' + @countryCodeIso
        end
    else
        select @returnLocale = @isoLanguage
    select @returnLocale
end

go
IF OBJECT_ID('dbo.wsp_getLocalefromLocaleId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getLocalefromLocaleId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getLocalefromLocaleId >>>'
go
EXEC sp_procxmode 'dbo.wsp_getLocalefromLocaleId','unchained'
go
GRANT EXECUTE ON dbo.wsp_getLocalefromLocaleId TO web
go
