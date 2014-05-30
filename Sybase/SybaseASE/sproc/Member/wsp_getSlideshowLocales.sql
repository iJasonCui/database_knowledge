IF OBJECT_ID('dbo.wsp_getSlideshowLocales') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getSlideshowLocales
    IF OBJECT_ID('dbo.wsp_getSlideshowLocales') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getSlideshowLocales >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getSlideshowLocales >>>'
END
go
  /***********************************************************************
**
** CREATION:
**   Author:  MIke Stairs
**   Date:  Aug 2004
**   Description:  Retrieves all the slideshow locale
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description: 
**
*************************************************************************/

CREATE PROCEDURE  wsp_getSlideshowLocales
AS

BEGIN
	SELECT localeId, 
               languageId, 
               countryId
	FROM   SlideshowLocale 
        ORDER BY localeId

	RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_getSlideshowLocales TO web
go
IF OBJECT_ID('dbo.wsp_getSlideshowLocales') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getSlideshowLocales >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getSlideshowLocales >>>'
go
EXEC sp_procxmode 'dbo.wsp_getSlideshowLocales','unchained'
go
