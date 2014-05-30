IF OBJECT_ID('dbo.wsp_getAllLocales') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getAllLocales
    IF OBJECT_ID('dbo.wsp_getAllLocales') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getAllLocales >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getAllLocales >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  May 21, 2003
**   Description:  retrieves all locales
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getAllLocales
AS
  BEGIN  
	SELECT 
          localeId,
          isoDesc
        FROM Locale
        ORDER BY localeId 
     RETURN @@error
  END
go
IF OBJECT_ID('dbo.wsp_getAllLocales') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getAllLocales >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getAllLocales >>>'
go
GRANT EXECUTE ON dbo.wsp_getAllLocales TO web
go

