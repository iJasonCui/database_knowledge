IF OBJECT_ID('dbo.wsp_getSlideShowByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getSlideShowByUserId
    IF OBJECT_ID('dbo.wsp_getSlideShowByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getSlideShowByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getSlideShowByUserId >>>'
END
go
  /***********************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  June 6, 2002
**   Description:  Retrieves profile data for a given user id
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*************************************************************************/

CREATE PROCEDURE wsp_getSlideShowByUserId
 @productCode   CHAR(1)
,@communityCode CHAR(1)
,@userId NUMERIC(12,0)
AS

BEGIN
	SELECT user_id
    ,timestamp
	FROM   a_mompictures_dating
	WHERE  user_id = @userId

	RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_getSlideShowByUserId TO web
go
IF OBJECT_ID('dbo.wsp_getSlideShowByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getSlideShowByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getSlideShowByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_getSlideShowByUserId','unchained'
go
