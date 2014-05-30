IF OBJECT_ID('dbo.wsp_getSearchOptionsByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getSearchOptionsByUserId
    IF OBJECT_ID('dbo.wsp_getSearchOptionsByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getSearchOptionsByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getSearchOptionsByUserId >>>'
END
go
  /***********************************************************************
**
** CREATION:
**   Author:  Cuneyt Tuna
**   Date:  Feb 13 2007
**   Description:  Retrieves user info for a given user id
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*************************************************************************/

CREATE PROCEDURE  wsp_getSearchOptionsByUserId
@userId NUMERIC(12,0)
AS

BEGIN
	SELECT user_id,
    community,
    from_age,
    to_age,
    perimeter,
    online_now,
    with_picture
	FROM SearchOptions
	WHERE user_id = @userId

	RETURN @@error
END

go
GRANT EXECUTE ON dbo.wsp_getSearchOptionsByUserId TO web
go
IF OBJECT_ID('dbo.wsp_getSearchOptionsByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getSearchOptionsByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getSearchOptionsByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_getSearchOptionsByUserId','unchained'
go
