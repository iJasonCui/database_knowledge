IF OBJECT_ID('dbo.wsp_getBillToMobileRespStatus') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getBillToMobileRespStatus
    IF OBJECT_ID('dbo.wsp_getBillToMobileRespStatus') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getBillToMobileRespStatus >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getBillToMobileRespStatus >>>'
END
go

/*******************************************************************
**
** CREATION:
**   Author:      Andy Tran
**   Date:        April 2011
**   Description: Selects row from BillToMobileResponse for the given
**                @xactionId.
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*******************************************************************/

CREATE PROCEDURE wsp_getBillToMobileRespStatus
 @xactionId  NUMERIC(12,0)
AS

BEGIN
    SELECT ISNULL(status, -1) as status
      FROM BillToMobileResponse
     WHERE xactionId = @xactionId
END
go

GRANT EXECUTE ON dbo.wsp_getBillToMobileRespStatus TO web
go

IF OBJECT_ID('dbo.wsp_getBillToMobileRespStatus') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getBillToMobileRespStatus >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getBillToMobileRespStatus >>>'
go

EXEC sp_procxmode 'dbo.wsp_getBillToMobileRespStatus','unchained'
go
