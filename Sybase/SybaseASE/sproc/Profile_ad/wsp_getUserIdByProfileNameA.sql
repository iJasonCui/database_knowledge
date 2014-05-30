IF OBJECT_ID('dbo.wsp_getUserIdByProfileNameA') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserIdByProfileNameA
    IF OBJECT_ID('dbo.wsp_getUserIdByProfileNameA') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserIdByProfileNameA >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserIdByProfileNameA >>>'
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

CREATE PROCEDURE  wsp_getUserIdByProfileNameA
 @productCode CHAR(1)
,@communityCode CHAR(1)
,@profileName VARCHAR(16)
,@userId NUMERIC(12,0) OUTPUT
AS

BEGIN
	SELECT @userId = user_id
	FROM a_profile_dating
	WHERE myidentity = @profileName
	AT ISOLATION READ UNCOMMITTED

	RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_getUserIdByProfileNameA TO web
go
IF OBJECT_ID('dbo.wsp_getUserIdByProfileNameA') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserIdByProfileNameA >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserIdByProfileNameA >>>'
go
EXEC sp_procxmode 'dbo.wsp_getUserIdByProfileNameA','unchained'
go
