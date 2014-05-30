USE Profile_ad
go
IF OBJECT_ID('dbo.wsp_getPendingListBg') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getPendingListBg
    IF OBJECT_ID('dbo.wsp_getPendingListBg') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getPendingListBg >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getPendingListBg >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  TK Chan
**   Date:  Sep 05 2008
**   Description:  retrieves list of new pending backstage greeting since timestamp and user_id
**
** REVISION(S):
**
******************************************************************************/

CREATE PROCEDURE  wsp_getPendingListBg
@rowcnt int,
@lastUserId numeric(12,0),
@lastSubmitTime int
AS
BEGIN
  SET ROWCOUNT @rowcnt

SELECT 
    user_id,   
    greeting,
    timestamp as submit_time,
    language
 
FROM dbo.a_backgreeting_dating
WHERE approved is null
AND 
        (timestamp > @lastSubmitTime OR
        (timestamp = @lastSubmitTime AND
        user_id > @lastUserId))

  ORDER BY timestamp,user_id
  AT ISOLATION READ UNCOMMITTED
     
  RETURN @@error
END
go
EXEC sp_procxmode 'dbo.wsp_getPendingListBg','unchained'
go
IF OBJECT_ID('dbo.wsp_getPendingListBg') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getPendingListBg >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getPendingListBg >>>'
go
GRANT EXECUTE ON dbo.wsp_getPendingListBg TO web
go
