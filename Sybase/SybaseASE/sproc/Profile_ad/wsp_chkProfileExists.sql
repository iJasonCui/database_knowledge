IF OBJECT_ID('dbo.wsp_chkProfileExists') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_chkProfileExists
    IF OBJECT_ID('dbo.wsp_chkProfileExists') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_chkProfileExists >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_chkProfileExists >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  November 2002
**   Description:  check to see if target has profile in given community
**
**          
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE  wsp_chkProfileExists
 @productCode CHAR(1)
,@communityCode CHAR(1)
,@userId NUMERIC(12,0)
,@targetUserId NUMERIC(12,0)
AS
BEGIN
	SELECT 1 
	FROM a_profile_dating
	WHERE user_id = @targetUserId 
	AND user_id  NOT IN 
		(SELECT userId 
		FROM Blocklist
		WHERE targetUserId = @userId
		AND userId = @targetUserId)
	AT ISOLATION READ UNCOMMITTED

	RETURN @@error
END
 
go
GRANT EXECUTE ON dbo.wsp_chkProfileExists TO web
go
IF OBJECT_ID('dbo.wsp_chkProfileExists') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_chkProfileExists >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_chkProfileExists >>>'
go
EXEC sp_procxmode 'dbo.wsp_chkProfileExists','unchained'
go
