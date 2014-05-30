IF OBJECT_ID('dbo.wsp_chkAdExists') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_chkAdExists
    IF OBJECT_ID('dbo.wsp_chkAdExists') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_chkAdExists >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_chkAdExists >>>'
END
go
  /***********************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  June 4, 2002
**   Description:  Checks existence of ad for a given user id
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*************************************************************************/

CREATE PROCEDURE wsp_chkAdExists
 @productCode   CHAR(1)
,@communityCode CHAR(1)
,@userId NUMERIC (12,0)
AS

BEGIN
	SELECT user_id
	FROM a_dating
	WHERE user_id = @userId

	RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_chkAdExists TO web
go
IF OBJECT_ID('dbo.wsp_chkAdExists') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_chkAdExists >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_chkAdExists >>>'
go
EXEC sp_procxmode 'dbo.wsp_chkAdExists','unchained'
go
