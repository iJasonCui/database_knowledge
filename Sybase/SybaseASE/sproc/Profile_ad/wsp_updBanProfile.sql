IF OBJECT_ID('dbo.wsp_updBanProfile') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updBanProfile
    IF OBJECT_ID('dbo.wsp_updBanProfile') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updBanProfile >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updBanProfile >>>'
END
go
/*************************************************************************
**
**
** CREATION:
**   Author:  Jack Veiga, Jeff Yang
**   Date:  Aug 20 2003
**   Description:  Updates show preferences to ban the profile 
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
**************************************************************************/

CREATE PROCEDURE wsp_updBanProfile
 @productCode   CHAR(1)
,@communityCode CHAR(1)
,@userId 		NUMERIC(12,0)
AS

BEGIN TRAN TRAN_updBanProfile

    UPDATE a_profile_dating 
	SET show_prefs = LOWER(show_prefs)
    WHERE user_id = @userId
    AND show_prefs = UPPER(show_prefs)

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_updBanProfile
            RETURN 0
        END
	ELSE
		BEGIN
			ROLLBACK TRAN TRAN_updBanProfile
			RETURN 99
		END
go
GRANT EXECUTE ON dbo.wsp_updBanProfile TO web
go
IF OBJECT_ID('dbo.wsp_updBanProfile') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updBanProfile >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updBanProfile >>>'
go
EXEC sp_procxmode 'dbo.wsp_updBanProfile','unchained'
go
