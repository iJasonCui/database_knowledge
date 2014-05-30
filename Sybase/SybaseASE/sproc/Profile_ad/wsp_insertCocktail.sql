IF OBJECT_ID('dbo.wsp_insertCocktail') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_insertCocktail
    IF OBJECT_ID('dbo.wsp_insertCocktail') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_insertCocktail >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_insertCocktail >>>'
END
go

/***********************************************************************
**
** CREATION:
**   Author:        Frank Qi
**   Date:          Oct 15, 2009
**   Description:   Insert Cooktial
**
**
*************************************************************************/

CREATE PROCEDURE  wsp_insertCocktail
 @targetUserId       NUMERIC(12,0),
 @sendUserId         NUMERIC(12,0),
 @cocktail         SMALLINT
AS

DECLARE @dateGMT            DATETIME
BEGIN

EXEC dbo.wsp_GetDateGMT @dateGMT OUTPUT

BEGIN TRAN TRAN_insertCocktail

        INSERT INTO Cocktail
        (
             sendUserId
            ,targetUserId
            ,cocktail
            ,counter
            ,dateModified
        )
        VALUES
        (
             @sendUserId
            ,@targetUserId
            ,@cocktail
            ,1
            ,@dateGMT
        )
         IF @@error = 0
           BEGIN
            COMMIT TRAN TRAN_insertCocktail
            RETURN 0
           END
         ELSE
           BEGIN
            ROLLBACK TRAN TRAN_insertCocktail
            RETURN 99
           END
END







go
EXEC sp_procxmode 'dbo.wsp_insertCocktail','unchained'
go
IF OBJECT_ID('dbo.wsp_insertCocktail') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_insertCocktail >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_insertCocktail >>>'
go
GRANT EXECUTE ON dbo.wsp_insertCocktail TO web
go
