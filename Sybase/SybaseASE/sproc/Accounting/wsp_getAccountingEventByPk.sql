IF OBJECT_ID('dbo.wsp_getAccountingEventByPk') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getAccountingEventByPk
    IF OBJECT_ID('dbo.wsp_getAccountingEventByPk') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getAccountingEventByPk >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getAccountingEventByPk >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:        Slobodan Kandic
**   Date:          Oct 03 2003 at 09:13AM
**   Description:
**
** REVISION(S):
 **   Author:       Andy Tran
 **   Date:         February 2008
 **   Description:  replace encodedCardNum with encodedCardId.
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getAccountingEventByPk
 @userId NUMERIC(12,0)
,@eventType CHAR(1)
,@dateCreated DATETIME
AS

BEGIN
    SELECT userId
          ,eventType
          ,xactionId
          ,encodedCardId
          ,encodedCardNum
          ,dateCreated
      FROM AccountingEvent
     WHERE userId = @userId
       AND dateCreated = @dateCreated
       AND eventType = @eventType
END
go

GRANT EXECUTE ON dbo.wsp_getAccountingEventByPk TO web
go

IF OBJECT_ID('dbo.wsp_getAccountingEventByPk') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getAccountingEventByPk >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getAccountingEventByPk >>>'
go

EXEC sp_procxmode 'dbo.wsp_getAccountingEventByPk','unchained'
go
