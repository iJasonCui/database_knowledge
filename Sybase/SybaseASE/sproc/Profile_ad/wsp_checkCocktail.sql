IF OBJECT_ID('dbo.wsp_checkCocktail') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_checkCocktail
    IF OBJECT_ID('dbo.wsp_checkCocktail') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_checkCocktail >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_checkCocktail >>>'
END
go

/***********************************************************************
**
** CREATION:
**   Author:       Frank Qi
**   Date:          Oct 2009
**   Description:   Check Cocktail exist
**
*************************************************************************/

CREATE PROCEDURE  wsp_checkCocktail
 @userId             NUMERIC(12,0),
 @sendUserId      NUMERIC(12,0),
 @cocktail            int
AS

BEGIN
   SELECT	cocktailId
    from dbo.Cocktail
    where targetUserId=@userId and
    sendUserId=@sendUserId and 
    cocktail=@cocktail
    
    AT ISOLATION READ UNCOMMITTED 

    RETURN @@error
END









go
EXEC sp_procxmode 'dbo.wsp_checkCocktail','unchained'
go
IF OBJECT_ID('dbo.wsp_checkCocktail') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_checkCocktail >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_checkCocktail >>>'
go
GRANT EXECUTE ON dbo.wsp_checkCocktail TO web
go
