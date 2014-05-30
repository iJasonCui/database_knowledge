IF OBJECT_ID('dbo.wsp_updAccountFlag') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updAccountFlag
    IF OBJECT_ID('dbo.wsp_updAccountFlag') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updAccountFlag >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updAccountFlag >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Slobodan Kandic
**   Date:  Aug 2003
**   Description:  Updates the AccountFlag table (just the reviewed field)
**
** REVISION(S):
**   Author: Mike Stairs
**   Date:  Oct 2003
**   Description: added adminUserId and dateModified
**
******************************************************************************/
CREATE PROCEDURE wsp_updAccountFlag
 @userId NUMERIC(12,0)
,@reviewed CHAR(1)
,@adminUserId INT

AS

DECLARE  @dateModified       DATETIME,
         @return 	     INT  
        
EXEC @return = dbo.wsp_GetDateGMT @dateModified OUTPUT
     
IF @return != 0
   BEGIN
	RETURN @return
   END

BEGIN TRAN TRAN_updAccountFlag

UPDATE AccountFlag SET
reviewed = @reviewed
,dateModified = @dateModified
,adminUserId = @adminUserId
WHERE
userId = @userId AND
reviewed != @reviewed
 
IF @@error = 0
    BEGIN
        COMMIT TRAN TRAN_updAccountFlag
        RETURN 0
    END
ELSE
    BEGIN
        ROLLBACK TRAN TRAN_updAccountFlag
        RETURN 99
    END
 
go
GRANT EXECUTE ON dbo.wsp_updAccountFlag TO web
go
IF OBJECT_ID('dbo.wsp_updAccountFlag') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updAccountFlag >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updAccountFlag >>>'
go
EXEC sp_procxmode 'dbo.wsp_updAccountFlag','unchained'
go
