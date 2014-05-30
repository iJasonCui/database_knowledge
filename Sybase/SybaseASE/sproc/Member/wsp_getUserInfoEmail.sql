IF OBJECT_ID('dbo.wsp_getUserInfoEmail') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserInfoEmail
    IF OBJECT_ID('dbo.wsp_getUserInfoEmail') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserInfoEmail >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserInfoEmail >>>'
END
go
  /***********************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  June 6, 2002
**   Description:  Retrieves email, etc for a given user id
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: June 23, 2004
**   Description: return localePref too
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: Sept 22, 2004
**   Description: return location related stuff too
**
*************************************************************************/

CREATE PROCEDURE  wsp_getUserInfoEmail
@userId        NUMERIC(12,0)
AS

BEGIN
	SELECT username,
               gender,
               birthdate,
               email, 
               1, 
               localePref, 
               countryId, 
               jurisdictionId, 
               secondJurisdictionId, 
               cityId
	FROM user_info
	WHERE user_id = @userId

	RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_getUserInfoEmail TO web
go
IF OBJECT_ID('dbo.wsp_getUserInfoEmail') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserInfoEmail >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserInfoEmail >>>'
go
EXEC sp_procxmode 'dbo.wsp_getUserInfoEmail','unchained'
go
