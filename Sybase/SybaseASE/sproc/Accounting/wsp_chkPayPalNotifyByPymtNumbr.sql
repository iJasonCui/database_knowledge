IF OBJECT_ID('dbo.wsp_chkPayPalNotifyByPymtNumbr') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_chkPayPalNotifyByPymtNumbr
    IF OBJECT_ID('dbo.wsp_chkPayPalNotifyByPymtNumbr') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_chkPayPalNotifyByPymtNumbr >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_chkPayPalNotifyByPymtNumbr >>>'
END
go

/*******************************************************************
**
** CREATION:
**   Author:      Andy Tran
**   Date:        July 2009 
**   Description: Returns record in PayPalNotify by paymentNumber
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*******************************************************************/

CREATE PROCEDURE wsp_chkPayPalNotifyByPymtNumbr
 @paymentNumber  VARCHAR(19)
AS

BEGIN
    BEGIN TRAN TRAN_chkPayPalNotify
        SELECT 1 AS isExisted
          FROM PayPalNotify
         WHERE paymentNumber = @paymentNumber

        IF @@error = 0
            BEGIN
                COMMIT TRAN TRAN_chkPayPalNotify
            END
        ELSE
            BEGIN
                ROLLBACK TRAN TRAN_chkPayPalNotify
            END
END
go

GRANT EXECUTE ON dbo.wsp_chkPayPalNotifyByPymtNumbr TO web
go

IF OBJECT_ID('dbo.wsp_chkPayPalNotifyByPymtNumbr') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_chkPayPalNotifyByPymtNumbr >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_chkPayPalNotifyByPymtNumbr >>>'
go

EXEC sp_procxmode 'dbo.wsp_chkPayPalNotifyByPymtNumbr','unchained'
go
