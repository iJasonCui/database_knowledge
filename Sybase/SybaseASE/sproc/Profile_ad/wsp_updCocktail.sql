IF OBJECT_ID('dbo.wsp_updCocktail') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updCocktail
    IF OBJECT_ID('dbo.wsp_updCocktail') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updCocktail >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updCocktail >>>'
END
go

/***********************************************************************
**
** CREATION:
**   Author:        Frank Qi
**   Date:          Oct 15, 2009
**   Description:   update Cooktial
**
**
*************************************************************************/

CREATE PROCEDURE  wsp_updCocktail
 @cocktailId         int 
AS

DECLARE @dateGMT            DATETIME
BEGIN

EXEC dbo.wsp_GetDateGMT @dateGMT OUTPUT

BEGIN TRAN TRAN_updCocktail

        UPDATE Cocktail  set counter=counter+1, dateModified=@dateGMT
        where cocktailId=@cocktailId
       
         IF @@error = 0
           BEGIN
            COMMIT TRAN TRAN_updCocktail
            RETURN 0
           END
         ELSE
           BEGIN
            ROLLBACK TRAN TRAN_updCocktail
            RETURN 99
           END
END






go
EXEC sp_procxmode 'dbo.wsp_updCocktail','unchained'
go
IF OBJECT_ID('dbo.wsp_updCocktail') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updCocktail >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updCocktail >>>'
go
GRANT EXECUTE ON dbo.wsp_updCocktail TO web
go
