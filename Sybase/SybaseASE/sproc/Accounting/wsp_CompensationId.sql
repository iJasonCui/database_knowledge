IF OBJECT_ID('dbo.wsp_CompensationId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_CompensationId
    IF OBJECT_ID('dbo.wsp_CompensationId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_CompensationId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_CompensationId >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author:  Jack Veiga, Mark Jaeckle
**   Date:  September 22 2003
**   Description:  Generation of compensationId
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_CompensationId @compensationId INT OUTPUT
AS

BEGIN TRAN TRAN_wsp_CompensationId
    UPDATE CompensationId
    SET compensationId = compensationId + 1

    IF @@error = 0
        BEGIN
            SELECT @compensationId = compensationId
            FROM CompensationId
            COMMIT TRAN TRAN_wsp_CompensationId
		  RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_wsp_CompensationId
		  RETURN 99
        END 
 
go
GRANT EXECUTE ON dbo.wsp_CompensationId TO web
go
IF OBJECT_ID('dbo.wsp_CompensationId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_CompensationId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_CompensationId >>>'
go
EXEC sp_procxmode 'dbo.wsp_CompensationId','unchained'
go
