IF OBJECT_ID('dbo.wsp_getAdTextByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getAdTextByUserId
    IF OBJECT_ID('dbo.wsp_getAdTextByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getAdTextByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getAdTextByUserId >>>'
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

CREATE PROCEDURE wsp_getAdTextByUserId
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
GRANT EXECUTE ON dbo.wsp_getAdTextByUserId TO web
go
IF OBJECT_ID('dbo.wsp_getAdTextByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getAdTextByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getAdTextByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_getAdTextByUserId','unchained'
go
