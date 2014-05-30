USE Accounting
go
IF OBJECT_ID('dbo.wsp_chkCall') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_chkCall
    IF OBJECT_ID('dbo.wsp_chkCall') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_chkCall >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_chkCall >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Jack Veiga/Yan Liu
**   Date:  July 2003
**   Description: Check if callId exists in Call
**
** REVISION(S)
**   Author:  Yadira Genoves Xolalpa
**   Date:  June/01/2010
**   Description: Added As returnVal
**
**
******************************************************************************/
CREATE PROCEDURE  wsp_chkCall
@callId INT

AS

IF EXISTS (SELECT 1  FROM Call WHERE callId = @callId)

	BEGIN
		SELECT 1 As returnVal
	END
ELSE
	BEGIN 
		SELECT 0 As returnVal
	END
go
EXEC sp_procxmode 'dbo.wsp_chkCall','unchained'
go
IF OBJECT_ID('dbo.wsp_chkCall') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_chkCall >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_chkCall >>>'
go
GRANT EXECUTE ON dbo.wsp_chkCall TO web
go
