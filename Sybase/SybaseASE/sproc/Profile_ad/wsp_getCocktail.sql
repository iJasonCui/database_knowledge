IF OBJECT_ID('dbo.wsp_getCocktail') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCocktail
    IF OBJECT_ID('dbo.wsp_getCocktail') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCocktail >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCocktail >>>'
END
go

/***********************************************************************
**
** CREATION:
**   Author:       Frank Qi
**   Date:          Oct 2009
**   Description:   Get Cocktail by user and community
**
*************************************************************************/

CREATE PROCEDURE  wsp_getCocktail
 @userId             NUMERIC(12,0)
AS

BEGIN
   SELECT	sendUserId, cocktail, counter
    from dbo.Cocktail
    where targetUserId=@userId 
    order by cocktail, dateModified
    AT ISOLATION READ UNCOMMITTED 

    RETURN @@error
END








go
EXEC sp_procxmode 'dbo.wsp_getCocktail','unchained'
go
IF OBJECT_ID('dbo.wsp_getCocktail') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getCocktail >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCocktail >>>'
go
GRANT EXECUTE ON dbo.wsp_getCocktail TO web
go
