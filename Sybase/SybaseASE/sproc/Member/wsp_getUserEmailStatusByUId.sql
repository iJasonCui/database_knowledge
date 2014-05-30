IF OBJECT_ID('dbo.wsp_getUserEmailStatusByUId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserEmailStatusByUId
    IF OBJECT_ID('dbo.wsp_getUserEmailStatusByUId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserEmailStatusByUId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserEmailStatusByUId >>>'
END
go
/******************************************************************************
 **
 ** CREATION:
 **   Author:  Yan L 
 **   Date:  November 13 2006
 **   Description:  Get UserEmailStatus data
 **
 ** REVISION(S):
 **   Author: 
 **   Date:
 **   Description: 
 **
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getUserEmailStatusByUId
    @userId NUMERIC(12, 0)
AS

BEGIN
    SELECT spamFlag,
           bounceBackFlag,
           dateCreated,
           dateModified
      FROM UserEmailStatus 
     WHERE userId = @userId

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getUserEmailStatusByUId TO web
go

IF OBJECT_ID('dbo.wsp_getUserEmailStatusByUId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserEmailStatusByUId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserEmailStatusByUId >>>'
go

EXEC sp_procxmode 'dbo.wsp_getUserEmailStatusByUId','unchained'
go
