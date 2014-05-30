IF OBJECT_ID('dbo.wsp_updProfileOfflineByUId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updProfileOfflineByUId
    IF OBJECT_ID('dbo.wsp_updProfileOfflineByUId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updProfileOfflineByUId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updProfileOfflineByUId >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Mark Jaeckle
**   Date:  November 12 2002
**   Description:  Update on_line Profile by user id
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_updProfileOfflineByUId
 @productCode CHAR(1)
,@communityCode CHAR(1)
,@userId NUMERIC(12,0)
AS
IF EXISTS (SELECT 1 FROM a_profile_dating
			WHERE user_id = @userId 
			AND (show_prefs IN ('O','N') 
			OR headline='' 
			OR headline IS NULL))

	BEGIN
		BEGIN TRAN TRAN_updProfileOfflineByUId
			UPDATE a_profile_dating
			SET show='N'
			,on_line='N'
			WHERE user_id = @userId

			IF @@error = 0
				BEGIN
					COMMIT TRAN TRAN_updProfileOfflineByUId
					RETURN 0
				END
			ELSE
				BEGIN
					ROLLBACK TRAN TRAN_updProfileOfflineByUId
					RETURN 99
				END
	END
ELSE
	BEGIN
		BEGIN TRAN TRAN_updProfileOfflineByUId
			UPDATE a_profile_dating
			SET on_line='N'
			WHERE user_id = @userId

           	IF @@error = 0
               	BEGIN
                   	COMMIT TRAN TRAN_updProfileOfflineByUId
                   	RETURN 0
               	END
           	ELSE
               	BEGIN
                   	ROLLBACK TRAN TRAN_updProfileOfflineByUId
                   	RETURN 99
               	END
	END
 
go
GRANT EXECUTE ON dbo.wsp_updProfileOfflineByUId TO web
go
IF OBJECT_ID('dbo.wsp_updProfileOfflineByUId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updProfileOfflineByUId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updProfileOfflineByUId >>>'
go
EXEC sp_procxmode 'dbo.wsp_updProfileOfflineByUId','unchained'
go
