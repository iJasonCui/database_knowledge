IF OBJECT_ID('dbo.wsp_getMacIeUser') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMacIeUser
    IF OBJECT_ID('dbo.wsp_getMacIeUser') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMacIeUser >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMacIeUser >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  November 2002
**   Description:  Get target user id for mac ie users by community
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/  
CREATE PROCEDURE dbo.wsp_getMacIeUser 
 @userId NUMERIC(12,0)
,@communityCode CHAR(1)
AS
BEGIN     
	SELECT target_user_id 
	FROM mac_ie_user
	WHERE user_id = @userId
	AND segment = @communityCode

	RETURN @@error
END         
 
go
GRANT EXECUTE ON dbo.wsp_getMacIeUser TO web
go
IF OBJECT_ID('dbo.wsp_getMacIeUser') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getMacIeUser >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMacIeUser >>>'
go
EXEC sp_procxmode 'dbo.wsp_getMacIeUser','unchained'
go
