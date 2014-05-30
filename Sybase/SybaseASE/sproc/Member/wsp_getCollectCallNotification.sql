IF OBJECT_ID('dbo.wsp_getCollectCallNotification') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCollectCallNotification
    IF OBJECT_ID('dbo.wsp_getCollectCallNotification') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCollectCallNotification >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCollectCallNotification >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:       Mike Stairs/Andy Tran/Jack Veiga
**   Date:         November 2002
**   Description:  used to determine if target accepts collect mails, msgType now ignored.
**
**
** REVISION(S):
**   Author:       Mike Stairs
**   Date:         Oct 2005
**   Description:  eliminated im references since we removed columns from user_info
**
**   Author:       Andy Tran
**   Date:         Feb 2007
**   Description:  always returns 'N' for mail preferences (collect call not accecpted)
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getCollectCallNotification
 @targetUserId NUMERIC(12,0) 
,@communityCode CHAR(1)
,@msgType CHAR(1)

AS
	BEGIN
		IF (@communityCode = 'i')
    		BEGIN
        		SELECT 'N' --mail_intimate
        		FROM user_info
        		WHERE user_id = @targetUserId
 
 		       RETURN @@error
    		END
		ELSE
		IF (@communityCode = 'r')
    		BEGIN
        		SELECT 'N' --mail_romance
        		FROM user_info
        		WHERE user_id = @targetUserId

        		RETURN @@error
    		END
		ELSE
		IF (@communityCode = 'd')
    		BEGIN
        		SELECT 'N' --mail_dating
        		FROM user_info
        		WHERE user_id = @targetUserId

        		RETURN @@error
    		END
	END
 
go
GRANT EXECUTE ON dbo.wsp_getCollectCallNotification TO web
go
IF OBJECT_ID('dbo.wsp_getCollectCallNotification') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getCollectCallNotification >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCollectCallNotification >>>'
go
EXEC sp_procxmode 'dbo.wsp_getCollectCallNotification','unchained'
go
