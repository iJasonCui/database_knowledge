IF OBJECT_ID('dbo.wsp_getUserInfoByIcqNumber') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserInfoByIcqNumber
    IF OBJECT_ID('dbo.wsp_getUserInfoByIcqNumber') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserInfoByIcqNumber >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserInfoByIcqNumber >>>'
END
go
  /***********************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  May 2004
**   Description:  Retrieves user info login info for a given icq number
**
**
*************************************************************************/

CREATE PROCEDURE  wsp_getUserInfoByIcqNumber
@icqNumber INT
AS

BEGIN
SELECT user_id
    ,username
    ,password
FROM user_info
WHERE icqNumber = @icqNumber

RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_getUserInfoByIcqNumber TO web
go
IF OBJECT_ID('dbo.wsp_getUserInfoByIcqNumber') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserInfoByIcqNumber >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserInfoByIcqNumber >>>'
go
EXEC sp_procxmode 'dbo.wsp_getUserInfoByIcqNumber','unchained'
go
