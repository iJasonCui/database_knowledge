IF OBJECT_ID('dbo.sp__languageMatched') IS NOT NULL
BEGIN
    DROP FUNCTION dbo.sp__languageMatched
    IF OBJECT_ID('dbo.sp__languageMatched') IS NOT NULL
        PRINT '<<< FAILED DROPPING FUNCTION dbo.sp__languageMatched >>>'
    ELSE
        PRINT '<<< DROPPED FUNCTION dbo.sp__languageMatched >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author: Mark Jaeckle
**   Date:  July 2010
**   Description: Returns true (1) if:
**      - @matchLanguage is true and @profileLanguageMask has at least one matching bit with @searchLanguageMask
**      OR
**      - @matchLanguage is false and @profileLanguageMask has no matching bits @searchLanguageMask
** 
** TEST CASES
**   select dbo.sp__languageMatched(4,2,0) --> 1
**   select dbo.sp__languageMatched(4,2,1) --> 0
**   select dbo.sp__languageMatched(4,4,0) --> 0
**   select dbo.sp__languageMatched(4,4,1) --> 1
**   select dbo.sp__languageMatched(7,3,0) --> 0
**   select dbo.sp__languageMatched(7,3,1) --> 1
**
** REVISION(S):
**   Author: 
**   Date:  
**   Description: 
**
******************************************************************************/
CREATE FUNCTION sp__languageMatched(
    @profileLanguageMask int,
    @searchLanguageMask int,
    @matchLanguage bit)
RETURNS bit
AS
BEGIN
    DECLARE @is_languageMatched bit
    IF (ISNULL(@profileLanguageMask,1) & @searchLanguageMask > 0)
        set @is_languageMatched = 1
    RETURN 1 - (@is_languageMatched ^ @matchLanguage)
END
go
GRANT EXECUTE ON dbo.sp__languageMatched TO public
go

