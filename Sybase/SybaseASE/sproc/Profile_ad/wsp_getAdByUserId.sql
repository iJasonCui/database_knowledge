IF OBJECT_ID('dbo.wsp_getAdByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getAdByUserId
    IF OBJECT_ID('dbo.wsp_getAdByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getAdByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getAdByUserId >>>'
END
go
  /***********************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  June 4, 2002
**   Description:  Retrieves ad for a given user id
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*************************************************************************/

CREATE PROCEDURE wsp_getAdByUserId
 @productCode   CHAR(1)
,@communityCode CHAR(1)
,@userId NUMERIC (12,0)
AS

BEGIN

    SELECT utext
    FROM a_dating
    WHERE user_id = @userId

    RETURN @@error

END 
 
go
GRANT EXECUTE ON dbo.wsp_getAdByUserId TO web
go
IF OBJECT_ID('dbo.wsp_getAdByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getAdByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getAdByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_getAdByUserId','unchained'
go
