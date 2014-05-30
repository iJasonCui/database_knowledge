IF OBJECT_ID('dbo.wsp_updProfileVideoByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updProfileVideoByUserId
    IF OBJECT_ID('dbo.wsp_updProfileVideoByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updProfileVideoByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updProfileVideoByUserId >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  September 2003
**   Description:  Update video profile by user id
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_updProfileVideoByUserId
 @productCode   CHAR(1)
,@communityCode CHAR(1)
,@video         CHAR(1)
,@userId        NUMERIC(12,0)
AS

BEGIN TRAN TRAN_updProfileVideoByUserId

	UPDATE a_profile_dating SET
	video = @video
	WHERE user_id = @userId

	IF @@error = 0
    	BEGIN
        	COMMIT TRAN TRAN_updProfileVideoByUserId
        	RETURN 0
    	END
	ELSE
    	BEGIN
        	ROLLBACK TRAN TRAN_updProfileVideoByUserId
        	RETURN 99
    	END
go
GRANT EXECUTE ON dbo.wsp_updProfileVideoByUserId TO web
go
IF OBJECT_ID('dbo.wsp_updProfileVideoByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updProfileVideoByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updProfileVideoByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_updProfileVideoByUserId','unchained'
go
