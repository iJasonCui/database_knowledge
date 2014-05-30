IF OBJECT_ID('dbo.wsp_getAccountingEventsByUser') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getAccountingEventsByUser
    IF OBJECT_ID('dbo.wsp_getAccountingEventsByUser') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getAccountingEventsByUser >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getAccountingEventsByUser >>>'
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

CREATE PROCEDURE dbo.wsp_getAccountingEventsByUser
 @userId NUMERIC(12,0)
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
    ORDER BY dateCreated
END
go

GRANT EXECUTE ON dbo.wsp_getAccountingEventsByUser TO web
go

IF OBJECT_ID('dbo.wsp_getAccountingEventsByUser') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getAccountingEventsByUser >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getAccountingEventsByUser >>>'
go

EXEC sp_procxmode 'dbo.wsp_getAccountingEventsByUser','unchained'
go
