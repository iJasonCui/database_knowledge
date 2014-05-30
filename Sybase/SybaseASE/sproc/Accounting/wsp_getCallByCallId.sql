IF OBJECT_ID('dbo.wsp_getCallByCallId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCallByCallId
    IF OBJECT_ID('dbo.wsp_getCallByCallId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCallByCallId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCallByCallId >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Yan Liu/Jack Veiga
**   Date:  September 2003
**   Description:  
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_getCallByCallId
@callId INT
AS

BEGIN
	SELECT payId
	,dateCreated
	FROM Call
	WHERE callId = @callId
END 
 
go
GRANT EXECUTE ON dbo.wsp_getCallByCallId TO web
go
IF OBJECT_ID('dbo.wsp_getCallByCallId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getCallByCallId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCallByCallId >>>'
go
EXEC sp_procxmode 'dbo.wsp_getCallByCallId','unchained'
go
