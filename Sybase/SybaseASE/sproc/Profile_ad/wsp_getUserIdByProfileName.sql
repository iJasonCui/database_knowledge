IF OBJECT_ID('dbo.wsp_getUserIdByProfileName') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserIdByProfileName
    IF OBJECT_ID('dbo.wsp_getUserIdByProfileName') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserIdByProfileName >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserIdByProfileName >>>'
END
go
 /***********************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  June 6, 2002
**   Description:  Retrieves user id from profile for a given profile name
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*************************************************************************/

CREATE PROCEDURE wsp_getUserIdByProfileName
 @productCode CHAR(1)
,@communityCode CHAR(1)
,@profileName VARCHAR(16)
,@userId NUMERIC(12,0) OUTPUT
AS

BEGIN
	SELECT @userId = user_id
	FROM a_profile_dating
	WHERE myidentity = @profileName
	AND show='Y' AND (show_prefs='Y' OR (show_prefs='O' AND on_line='Y'))
	AT ISOLATION READ UNCOMMITTED

	RETURN @@error
END 
 
 
go
GRANT EXECUTE ON dbo.wsp_getUserIdByProfileName TO web
go
IF OBJECT_ID('dbo.wsp_getUserIdByProfileName') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserIdByProfileName >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserIdByProfileName >>>'
go
EXEC sp_procxmode 'dbo.wsp_getUserIdByProfileName','unchained'
go
