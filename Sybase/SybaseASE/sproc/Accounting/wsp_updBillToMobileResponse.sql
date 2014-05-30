IF OBJECT_ID('dbo.wsp_updBillToMobileResponse') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updBillToMobileResponse
    IF OBJECT_ID('dbo.wsp_updBillToMobileResponse') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updBillToMobileResponse >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updBillToMobileResponse >>>'
END
go

/*******************************************************************
**
** CREATION:
**   Author:      Andy Tran
**   Date:        April 2011 
**   Description: Updates row in BillToMobileResponse.
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*******************************************************************/

CREATE PROCEDURE wsp_updBillToMobileResponse
 @xactionId  NUMERIC(12,0)
,@status     TINYINT
AS

DECLARE
 @dateNow DATETIME
,@return  INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

IF EXISTS (SELECT 1 FROM BillToMobileResponse WHERE xactionId = @xactionId)
    BEGIN
	    BEGIN TRAN TRAN_updBillToMobileResponse
	        UPDATE BillToMobileResponse
	           SET status = @status
	              ,dateModified = @dateNow
	         WHERE xactionId = @xactionId
	        
            IF @@error != 0
                BEGIN
                    ROLLBACK TRAN TRAN_updBillToMobileResponse
                    RETURN 99
                END

            COMMIT TRAN TRAN_updBillToMobileResponse
            RETURN 0
    END
go

GRANT EXECUTE ON dbo.wsp_updBillToMobileResponse TO web
go

IF OBJECT_ID('dbo.wsp_updBillToMobileResponse') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updBillToMobileResponse >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updBillToMobileResponse >>>'
go

EXEC sp_procxmode 'dbo.wsp_updBillToMobileResponse','unchained'
go
