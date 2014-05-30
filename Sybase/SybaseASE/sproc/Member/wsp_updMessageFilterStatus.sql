IF OBJECT_ID('dbo.wsp_updMessageFilterStatus') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updMessageFilterStatus
    IF OBJECT_ID('dbo.wsp_updMessageFilterStatus') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updMessageFilterStatus >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updMessageFilterStatus >>>'
END
go

/***********************************************************************
**
** CREATION:
**   Author:        Andy Tran
**   Date:          August 2011
**   Description:   Updates MessageFilter status record
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*************************************************************************/

CREATE PROCEDURE  wsp_updMessageFilterStatus
 @userId  NUMERIC(12,0)
,@status  CHAR(1)
AS

DECLARE
 @return  INT
,@dateNow DATETIME

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN TRAN TRAN_updMessageFilter

    IF EXISTS (SELECT 1 FROM MessageFilter WHERE userId = @userId)
        BEGIN
            UPDATE MessageFilter
               SET status = @status
                  ,dateModified = @dateNow
             WHERE userId = @userId

            IF @@error != 0
                BEGIN
                    ROLLBACK TRAN TRAN_updMessageFilter
                    RETURN 99
                END

            COMMIT TRAN TRAN_updMessageFilter
            RETURN 0
        END
go

IF OBJECT_ID('dbo.wsp_updMessageFilterStatus') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updMessageFilterStatus >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updMessageFilterStatus >>>'
go

EXEC sp_procxmode 'dbo.wsp_updMessageFilterStatus','unchained'
go

GRANT EXECUTE ON dbo.wsp_updMessageFilterStatus TO web
go
