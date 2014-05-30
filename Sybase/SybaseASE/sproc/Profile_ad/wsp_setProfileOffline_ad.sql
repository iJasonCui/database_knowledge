IF OBJECT_ID('dbo.wsp_setProfileOffline_ad') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_setProfileOffline_ad
    IF OBJECT_ID('dbo.wsp_setProfileOffline_ad') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_setProfileOffline_ad >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_setProfileOffline_ad >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Apr 18 2002
**   Description:  marks profile online status to offline when session expires
**
** REVISION(S):
**   Author:  Jack Veiga
**   Date:  November 2002
**   Description:  Removed references to search searchpref due to new Profile
**                 data base model
**
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_setProfileOffline_ad
@userId NUMERIC(12,0)
AS
BEGIN TRAN TRAN_setProfileOffline_ad
	IF EXISTS (SELECT 1 FROM a_profile_dating
				WHERE user_id = @userId 
				AND (show_prefs IN ('O','N') OR headline='' OR headline IS NULL))

		BEGIN
			UPDATE a_profile_dating
			SET show='N'
			,on_line='N'
			WHERE user_id = @userId

			IF @@error = 0
				BEGIN
					COMMIT TRAN TRAN_setProfileOffline_ad
					RETURN 0
				END
			ELSE
				BEGIN
					ROLLBACK TRAN TRAN_setProfileOffline_ad
					RETURN 99
				END
		END
	ELSE
		BEGIN
			UPDATE a_profile_dating
			SET on_line='N'
			WHERE user_id = @userId

            IF @@error = 0
                BEGIN
                    COMMIT TRAN TRAN_setProfileOffline_ad
                    RETURN 0
                END
            ELSE
                BEGIN
                    ROLLBACK TRAN TRAN_setProfileOffline_ad
                    RETURN 99
                END
        END
 
go
GRANT EXECUTE ON dbo.wsp_setProfileOffline_ad TO web
go
IF OBJECT_ID('dbo.wsp_setProfileOffline_ad') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_setProfileOffline_ad >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_setProfileOffline_ad >>>'
go
EXEC sp_procxmode 'dbo.wsp_setProfileOffline_ad','unchained'
go
