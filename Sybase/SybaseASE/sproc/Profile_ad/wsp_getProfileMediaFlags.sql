USE Profile_ad
go
IF OBJECT_ID('dbo.wsp_getProfileMediaFlags') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getProfileMediaFlags
    IF OBJECT_ID('dbo.wsp_getProfileMediaFlags') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getProfileMediaFlags >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getProfileMediaFlags >>>'
END
go
/***********************************************************************
**
** CREATION:
**   Author:  Alex L
**   Date:  July 16 2008
**   Description:  Retrieves media related flags
**
*************************************************************************/

CREATE PROCEDURE  wsp_getProfileMediaFlags
 @productCode   CHAR(1)
,@communityCode CHAR(1)
,@userId NUMERIC(12,0)
AS

BEGIN
	SELECT headline,
                  pict,
                  backstage,
                  gallery
	FROM   a_profile_dating
	WHERE  user_id = @userId
	AT ISOLATION READ UNCOMMITTED

	RETURN @@error
END
go
EXEC sp_procxmode 'dbo.wsp_getProfileMediaFlags','unchained'
go
IF OBJECT_ID('dbo.wsp_getProfileMediaFlags') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getProfileMediaFlags >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getProfileMediaFlags >>>'
go
GRANT EXECUTE ON dbo.wsp_getProfileMediaFlags TO web
go
