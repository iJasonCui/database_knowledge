IF OBJECT_ID('dbo.wsp_getSDAccount') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getSDAccount
    IF OBJECT_ID('dbo.wsp_getSDAccount') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getSDAccount >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getSDAccount >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         June 1, 2009
**   Description:  Retrieve SD account
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getSDAccount
 @userId             NUMERIC(12,0)

AS
BEGIN
    SELECT passOfferId
          ,dateCreated
          ,dateModified
          ,dateExpiry
      FROM SDAccount
     WHERE userId = @userId

     RETURN @@error
END
go

IF OBJECT_ID('dbo.wsp_getSDAccount') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getSDAccount >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getSDAccount >>>'
go

GRANT EXECUTE ON dbo.wsp_getSDAccount TO web
go
