IF OBJECT_ID('dbo.wsp_getDeclineCode') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getDeclineCode
    IF OBJECT_ID('dbo.wsp_getDeclineCode') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getDeclineCode >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getDeclineCode >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:  Yan Liu 
**   Date:  July 28 2008 
**   Description:  get decline code. 
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getDeclineCode
AS

BEGIN
   SELECT declineCode, 
          retrialFlag 
     FROM DeclineCode 

   RETURN @@error 
END
go

IF OBJECT_ID('dbo.wsp_getDeclineCode') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getDeclineCode >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getDeclineCode >>>'
go

GRANT EXECUTE ON dbo.wsp_getDeclineCode TO web
go

