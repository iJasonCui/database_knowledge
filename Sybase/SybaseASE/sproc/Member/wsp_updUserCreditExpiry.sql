IF OBJECT_ID('dbo.wsp_updUserCreditExpiry') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updUserCreditExpiry
    IF OBJECT_ID('dbo.wsp_updUserCreditExpiry') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updUserCreditExpiry >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updUserCreditExpiry >>>'
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

CREATE PROCEDURE wsp_updUserCreditExpiry
    @userId        NUMERIC(12,0),
    @userLastOn    INT,
    @emailStatus   CHAR(1),
    @dateEmailSent DATETIME,
    @dateModified  DATETIME
AS
     
BEGIN TRAN TRAN_updUserCreditExpiry
    BEGIN
        UPDATE UserCreditExpiry
           SET emailStatus   = @emailStatus,
               dateEmailSent = @dateEmailSent,
               dateModified  = @dateModified
         WHERE userId = @userId
           AND userLastOn = @userLastOn    

        IF @@error = 0
            BEGIN
                COMMIT TRAN TRAN_updUserCreditExpiry
                RETURN 0
            END
        ELSE
            BEGIN
                ROLLBACK TRAN TRAN_updUserCreditExpiry
                RETURN 99
            END
    END
go

GRANT EXECUTE ON dbo.wsp_updUserCreditExpiry TO web
go

IF OBJECT_ID('dbo.wsp_updUserCreditExpiry') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updUserCreditExpiry >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updUserCreditExpiry >>>'
go
EXEC sp_procxmode 'dbo.wsp_updUserCreditExpiry','unchained'
go
