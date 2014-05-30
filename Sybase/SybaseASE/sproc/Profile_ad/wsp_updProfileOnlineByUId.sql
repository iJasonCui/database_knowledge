IF OBJECT_ID('dbo.wsp_updProfileOnlineByUId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updProfileOnlineByUId
    IF OBJECT_ID('dbo.wsp_updProfileOnlineByUId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updProfileOnlineByUId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updProfileOnlineByUId >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Mark Jaeckle
**   Date:  October 23 2002
**   Description:  Update laston and on_line Profile by user id
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: Feb 2005
**   Description: also return profileLanguageMask
**
******************************************************************************/

CREATE PROCEDURE wsp_updProfileOnlineByUId
 @productCode CHAR(1)
,@communityCode CHAR(1)
,@laston INT
,@userId NUMERIC(12,0)
AS
DECLARE @show CHAR(1)

SELECT @show = 'Y'

IF EXISTS (SELECT 1
			FROM a_profile_dating
			WHERE user_id = @userId
			AND show_prefs != 'N' 
			AND headline != '' 
			AND headline != NULL)

	BEGIN
		BEGIN TRAN TRAN_updProfileOnlineByUId

			UPDATE a_profile_dating
			SET show = 'Y'
			,on_line = 'Y'
			,laston = @laston
			WHERE user_id = @userId

			IF @@error = 0
				BEGIN
					COMMIT TRAN TRAN_updProfileOnlineByUId
				END
			ELSE
				BEGIN
					ROLLBACK TRAN TRAN_updProfileOnlineByUId
					RETURN 99
				END
	END
ELSE
	BEGIN
		SELECT @show = 'N'
		BEGIN TRAN TRAN_updProfileOnlineByUId

			UPDATE a_profile_dating
			SET on_line = 'Y'
			,laston = @laston
			WHERE user_id = @userId

			IF @@error = 0
				BEGIN
					COMMIT TRAN TRAN_updProfileOnlineByUId
				END
			ELSE
				BEGIN
					ROLLBACK TRAN TRAN_updProfileOnlineByUId
					RETURN 99
				END
	END

IF @show = 'Y'
	BEGIN
		SELECT 'Y',pict,profileLanguageMask
		FROM a_profile_dating
		WHERE user_id = @userId
		AT ISOLATION READ UNCOMMITTED

		RETURN 0
	END
ELSE
	BEGIN
		SELECT 'N','N',0
		
		RETURN 0
	END
 
go
GRANT EXECUTE ON dbo.wsp_updProfileOnlineByUId TO web
go
IF OBJECT_ID('dbo.wsp_updProfileOnlineByUId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updProfileOnlineByUId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updProfileOnlineByUId >>>'
go
EXEC sp_procxmode 'dbo.wsp_updProfileOnlineByUId','unchained'
go
