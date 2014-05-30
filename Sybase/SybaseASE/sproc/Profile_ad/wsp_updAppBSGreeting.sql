IF OBJECT_ID('dbo.wsp_updAppBSGreeting') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updAppBSGreeting
    IF OBJECT_ID('dbo.wsp_updAppBSGreeting') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updAppBSGreeting >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updAppBSGreeting >>>'
END
go
  /***********************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  May 24 2002
**   Description:  Updates backstage greeting
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: April 2004
**   Description: pass language parameter
**
*************************************************************************/

CREATE PROCEDURE  wsp_updAppBSGreeting
 @productCode CHAR(1)
,@communityCode CHAR(1)
,@userId NUMERIC(12,0)
,@language TINYINT
,@timestamp INT
,@approved CHAR(1)
AS

BEGIN TRAN TRAN_updAppBSGreeting
UPDATE a_backgreeting_dating
SET approved=@approved,
    language=@language
WHERE user_id=@userId
AND timestamp=@timestamp
IF @@error = 0
  BEGIN
    COMMIT TRAN TRAN_updAppBSGreeting
    RETURN 0
  END
ELSE
  BEGIN
    ROLLBACK TRAN TRAN_updAppBSGreeting
    RETURN 99
  END 
 
go
GRANT EXECUTE ON dbo.wsp_updAppBSGreeting TO web
go
IF OBJECT_ID('dbo.wsp_updAppBSGreeting') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updAppBSGreeting >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updAppBSGreeting >>>'
go
EXEC sp_procxmode 'dbo.wsp_updAppBSGreeting','unchained'
go
