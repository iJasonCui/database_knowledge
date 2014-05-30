IF OBJECT_ID('dbo.wsp_getCallResult') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCallResult
    IF OBJECT_ID('dbo.wsp_getCallResult') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCallResult >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCallResult >>>'
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

CREATE PROCEDURE wsp_getCallResult 

AS

SELECT callResultId,
       callResultName,
       billedFlag
  FROM CallResult

RETURN @@error
go
IF OBJECT_ID('dbo.wsp_getCallResult') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getCallResult >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCallResult >>>'
go
EXEC sp_procxmode 'dbo.wsp_getCallResult','anymode'
go
GRANT EXECUTE ON dbo.wsp_getCallResult TO web
go
