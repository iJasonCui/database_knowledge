IF OBJECT_ID('dbo.wsp_getSubTransDynaContent') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getSubTransDynaContent
    IF OBJECT_ID('dbo.wsp_getSubTransDynaContent') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getSubTransDynaContent >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getSubTransDynaContent >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:  Yan Liu 
**   Date:  Janunary 29 2009 
**   Description:  get SubTransactionDynaContent 
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getSubTransDynaContent
   @xactionId INT
AS

BEGIN
   SELECT sequenceId, 
          content 
     FROM SubTransactionDynaContent
    WHERE xactionId = @xactionId
   ORDER BY sequenceId ASC

   RETURN 0
END
go

IF OBJECT_ID('dbo.wsp_getSubTransDynaContent') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getSubTransDynaContent >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getSubTransDynaContent >>>'
go

GRANT EXECUTE ON dbo.wsp_getSubTransDynaContent TO web
go

