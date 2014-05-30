IF OBJECT_ID('dbo.wsp_UniversalId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_UniversalId
    IF OBJECT_ID('dbo.wsp_UniversalId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_UniversalId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_UniversalId >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  July 9 2002
**   Description:  Generation of universalId
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_UniversalId @universalId INT OUTPUT
AS

BEGIN TRAN TRAN_wsp_UniversalId
    UPDATE UniversalId
    SET universalId = universalId + 1

    IF @@error = 0
        BEGIN
            SELECT @universalId = universalId
            FROM UniversalId
            COMMIT TRAN TRAN_wsp_UniversalId
		  RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_wsp_UniversalId
		  RETURN 99
        END
 
go
GRANT EXECUTE ON dbo.wsp_UniversalId TO web
go
IF OBJECT_ID('dbo.wsp_UniversalId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_UniversalId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_UniversalId >>>'
go
EXEC sp_procxmode 'dbo.wsp_UniversalId','unchained'
go
