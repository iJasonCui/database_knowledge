IF OBJECT_ID('dbo.wsp_saveUserCreditExpiry') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveUserCreditExpiry
    IF OBJECT_ID('dbo.wsp_saveUserCreditExpiry') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveUserCreditExpiry >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveUserCreditExpiry >>>'
END
go
  /******************************************************************
**
** CREATION:
**   Author: Yan Liu	 
**   Date:  Mar 15 2004
**   Description: save UserCreditExpiry
**           
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_saveUserCreditExpiry
    @userId        NUMERIC(12,0),
    @userLastOn    INT,
    @emailStatus   CHAR(1)
AS
     
DECLARE @date DATETIME
EXEC wsp_GetDateGMT @date OUTPUT

IF EXISTS(SELECT 1 FROM UserCreditExpiry
           WHERE userId     = @userId
             AND userLastOn = @userLastOn) 
    BEGIN
       EXEC wsp_updUserCreditExpiry @userId,
                                    @userLastOn,
                                    @emailStatus,
                                    @date,
                                    @date
    END
ELSE 
    BEGIN
       EXEC wsp_newUserCreditExpiry @userId,
                                    @userLastOn,
                                    @emailStatus,
                                    @date,
                                    @date
    END
go

GRANT EXECUTE ON dbo.wsp_saveUserCreditExpiry TO web
go

IF OBJECT_ID('dbo.wsp_saveUserCreditExpiry') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_saveUserCreditExpiry >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveUserCreditExpiry >>>'
go
EXEC sp_procxmode 'dbo.wsp_saveUserCreditExpiry','unchained'
go
