IF OBJECT_ID('dbo.wsp_updUnBanProfile') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updUnBanProfile
    IF OBJECT_ID('dbo.wsp_updUnBanProfile') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updUnBanProfile >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updUnBanProfile >>>'
END
go
/*************************************************************************
**
**
** CREATION:
**   Author:  Jack Veiga, Jeff Yang
**   Date:  August 2003
**   Description:  Updates show preferences for a given user id
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
**************************************************************************/

CREATE PROCEDURE wsp_updUnBanProfile
 @productCode   CHAR(1)
,@communityCode CHAR(1)
,@userId 		NUMERIC(12,0)
AS

BEGIN TRAN TRAN_updUnBanProfile

    UPDATE a_profile_dating 
	SET show_prefs = "Y" 
    WHERE user_id = @userId

     IF @@error = 0
         BEGIN
             COMMIT TRAN TRAN_updUnBanProfile
             RETURN 0
         END
     ELSE
         BEGIN
             ROLLBACK TRAN TRAN_updUnBanProfile
             RETURN 99
         END
go
GRANT EXECUTE ON dbo.wsp_updUnBanProfile TO web
go
IF OBJECT_ID('dbo.wsp_updUnBanProfile') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updUnBanProfile >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updUnBanProfile >>>'
go
EXEC sp_procxmode 'dbo.wsp_updUnBanProfile','unchained'
go
