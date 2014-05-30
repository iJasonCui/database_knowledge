IF OBJECT_ID('dbo.wsp_getAllLanguages') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getAllLanguages
    IF OBJECT_ID('dbo.wsp_getAllLanguages') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getAllLanguages >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getAllLanguages >>>'
END
go
  /***********************************************************************
**
** CREATION:
**   Author:  Valeri Popov
**   Date:  Apr. 8, 2004
**   Description:  Retrieves all the languages
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: May 25, 2004
**   Description: force order by id
**
*************************************************************************/

CREATE PROCEDURE  wsp_getAllLanguages
AS

BEGIN
	SELECT languageId, isoLanguage, languageLabelKey, languageMask, isSpoken, isProfile
	FROM Language
        ORDER BY languageId

	RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_getAllLanguages TO web
go
IF OBJECT_ID('dbo.wsp_getAllLanguages') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getAllLanguages >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getAllLanguages >>>'
go
EXEC sp_procxmode 'dbo.wsp_getAllLanguages','unchained'
go
