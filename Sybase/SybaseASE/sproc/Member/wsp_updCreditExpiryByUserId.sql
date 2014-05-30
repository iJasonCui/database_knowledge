IF OBJECT_ID('dbo.wsp_updCreditExpiryByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updCreditExpiryByUserId
    IF OBJECT_ID('dbo.wsp_updCreditExpiryByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updCreditExpiryByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updCreditExpiryByUserId >>>'
END
go
  /******************************************************************
**
** CREATION:
**   Author: Yan Liu	 
**   Date:  Mar 15 2004
**   Description: update UserCreditExpiry
**           
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_updCreditExpiryByUserId
    @userId        NUMERIC(12,0),
    @userLastOn    INT,
    @emailStatus   CHAR(1)
AS
     
DECLARE @date DATETIME
EXEC wsp_GetDateGMT @date OUTPUT

BEGIN TRAN TRAN_updCreditExpiryByUserId
    BEGIN
        UPDATE UserCreditExpiry
           SET emailStatus  = @emailStatus,
               dateModified = @date
         WHERE userId     = @userId
           AND userLastOn = @userLastOn    

        IF @@error = 0
            BEGIN
                COMMIT TRAN TRAN_updCreditExpiryByUserId
                RETURN 0
            END
        ELSE
            BEGIN
                ROLLBACK TRAN TRAN_updCreditExpiryByUserId
                RETURN 99
            END
    END
go

GRANT EXECUTE ON dbo.wsp_updCreditExpiryByUserId TO web
go

IF OBJECT_ID('dbo.wsp_updCreditExpiryByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updCreditExpiryByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updCreditExpiryByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_updCreditExpiryByUserId','unchained'
go
