IF OBJECT_ID('dbo.wsp_getUserProfileHighlight') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserProfileHighlight
    IF OBJECT_ID('dbo.wsp_getUserProfileHighlight') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserProfileHighlight >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserProfileHighlight >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:      Andy Tran
**   Date:        November 3, 2005
**   Description: Returns UserProfileHighlight value object
**
** REVISION(S):
**   Author:        
**   Date:          
**   Description:   
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getUserProfileHighlight
 @userId NUMERIC(12,0)
AS

BEGIN
    SELECT dateExpiry
      FROM UserProfileHighlight
     WHERE userId = @userId

    RETURN @@error

END
go

GRANT EXECUTE ON dbo.wsp_getUserProfileHighlight TO web
go

IF OBJECT_ID('dbo.wsp_getUserProfileHighlight') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserProfileHighlight >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserProfileHighlight >>>'
go

EXEC sp_procxmode 'dbo.wsp_getUserProfileHighlight','unchained'
go
