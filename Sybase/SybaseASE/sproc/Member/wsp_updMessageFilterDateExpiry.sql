IF OBJECT_ID('dbo.wsp_updMessageFilterDateExpiry') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updMessageFilterDateExpiry
    IF OBJECT_ID('dbo.wsp_updMessageFilterDateExpiry') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updMessageFilterDateExpiry >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updMessageFilterDateExpiry >>>'
END
go

/***********************************************************************
**
** CREATION:
**   Author:        Andy Tran
**   Date:          August 2011
**   Description:   Updates MessageFilter dateExpiry record
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*************************************************************************/

CREATE PROCEDURE  wsp_updMessageFilterDateExpiry
 @userId     NUMERIC(12,0)
,@dateExpiry DATETIME
AS

DECLARE
 @return     INT
,@dateNow    DATETIME

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN TRAN TRAN_updMessageFilter

    IF EXISTS (SELECT 1 FROM MessageFilter WHERE userId = @userId)
        BEGIN
            UPDATE MessageFilter
               SET dateExpiry = @dateExpiry
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

IF OBJECT_ID('dbo.wsp_updMessageFilterDateExpiry') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updMessageFilterDateExpiry >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updMessageFilterDateExpiry >>>'
go

EXEC sp_procxmode 'dbo.wsp_updMessageFilterDateExpiry','unchained'
go

GRANT EXECUTE ON dbo.wsp_updMessageFilterDateExpiry TO web
go
