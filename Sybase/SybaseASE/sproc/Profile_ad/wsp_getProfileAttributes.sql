IF OBJECT_ID('dbo.wsp_getProfileAttributes') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getProfileAttributes
    IF OBJECT_ID('dbo.wsp_getProfileAttributes') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getProfileAttributes >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getProfileAttributes >>>'
END
go
  /***********************************************************************
**
** CREATION:
**   Author:  Jeff Yang 
**   Date:  Oct 6, 2002
**   Description:  Retrieves profile data for a given user id
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*************************************************************************/

CREATE PROCEDURE  wsp_getProfileAttributes
 @productCode   CHAR(1)
,@communityCode CHAR(1)
,@userId NUMERIC(12,0)
AS

BEGIN
	SELECT attributes 
	FROM   a_profile_dating
	WHERE  user_id = @userId
	AT ISOLATION READ UNCOMMITTED

	RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_getProfileAttributes TO web
go
IF OBJECT_ID('dbo.wsp_getProfileAttributes') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getProfileAttributes >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getProfileAttributes >>>'
go
EXEC sp_procxmode 'dbo.wsp_getProfileAttributes','unchained'
go
