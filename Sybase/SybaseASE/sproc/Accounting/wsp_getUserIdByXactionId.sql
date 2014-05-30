IF OBJECT_ID('dbo.wsp_getUserIdByXactionId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserIdByXactionId
    IF OBJECT_ID('dbo.wsp_getUserIdByXactionId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserIdByXactionId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserIdByXactionId >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  September 2003
**   Description:  returns userId for given purchase xactionId
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_getUserIdByXactionId
 @xactionId 				NUMERIC(12,0)
AS

BEGIN
  SELECT userId FROM Purchase WHERE xactionId = @xactionId AT ISOLATION READ UNCOMMITTED
  
  RETURN @@error

END
go
GRANT EXECUTE ON dbo.wsp_getUserIdByXactionId TO web
go
IF OBJECT_ID('dbo.wsp_getUserIdByXactionId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserIdByXactionId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserIdByXactionId >>>'
go
